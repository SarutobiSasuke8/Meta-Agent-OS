#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

# End-to-end tests for scripts/check-meta-agent-os.ps1. Each test copies the
# repository (without .git) into $TestDrive, breaks one thing, and runs the
# checker in a child process of the same PowerShell edition, asserting the exit
# code and the reported message. The checker resolves the repo root from its own
# location, so the copy is checked, never the working tree.
#
# No network, no credentials. This file is scanned by the checker's leak scan,
# so leak fixtures are assembled at run time rather than written literally.

BeforeAll {
    $script:RepoRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, '..'))
    $script:Shell = (Get-Process -Id $PID).Path

    function Copy-RepoToTestDrive {
        $dest = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $dest | Out-Null
        Get-ChildItem -LiteralPath $script:RepoRoot -Force |
            Where-Object { $_.Name -ne '.git' } |
            ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force }
        return $dest
    }

    function Get-CopyPath {
        param([string]$Copy, [string]$RelativePath)
        return [System.IO.Path]::Combine([string[]](@($Copy) + ($RelativePath -split '/')))
    }

    function Add-ToFile {
        param([string]$Copy, [string]$RelativePath, [string]$Text)
        $path = Get-CopyPath $Copy $RelativePath
        [System.IO.File]::AppendAllText($path, "`n$Text`n")
    }

    function Edit-JsonFile {
        param([string]$Copy, [string]$RelativePath, [scriptblock]$Change)
        $path = Get-CopyPath $Copy $RelativePath
        $data = Get-Content -Raw -LiteralPath $path | ConvertFrom-Json
        & $Change $data
        [System.IO.File]::WriteAllText($path, ($data | ConvertTo-Json -Depth 20))
    }

    function Invoke-Checker {
        param([string]$Copy, [switch]$Strict, [switch]$Json)
        $checker = Get-CopyPath $Copy 'scripts/check-meta-agent-os.ps1'
        $checkerArgs = @()
        if ($Strict) { $checkerArgs += '-Strict' }
        if ($Json) { $checkerArgs += '-Json' }
        $output = & $script:Shell -NoProfile -NonInteractive -File $checker @checkerArgs 2>&1 | Out-String
        return [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $output }
    }
}

Describe 'check-meta-agent-os.ps1 end to end' {
    BeforeEach {
        Mock Invoke-RestMethod { throw 'Network call attempted in a unit test.' }
        Mock Invoke-WebRequest { throw 'Network call attempted in a unit test.' }
        Mock Start-Process { throw 'Process launch attempted in a unit test.' }
    }

    Context 'the repository as committed' {
        BeforeAll {
            $script:Clean = Copy-RepoToTestDrive
        }

        It 'passes the default check' {
            $r = Invoke-Checker $script:Clean
            $r.ExitCode | Should -Be 0
            $r.Output | Should -Match 'Meta Agent OS hardening check passed\.'
        }

        It 'passes the strict check' {
            $r = Invoke-Checker $script:Clean -Strict
            $r.ExitCode | Should -Be 0
            $r.Output | Should -Match 'passed in strict mode'
        }

        It 'emits machine-readable JSON with -Json' {
            $r = Invoke-Checker $script:Clean -Strict -Json
            $r.ExitCode | Should -Be 0
            $result = $r.Output | ConvertFrom-Json
            $result.ok | Should -BeTrue
            $result.strict | Should -BeTrue
            $result.error_count | Should -Be 0
        }
    }

    Context 'failures in default mode' {
        It 'reports a missing required file and exits 1' {
            $copy = Copy-RepoToTestDrive
            Remove-Item -LiteralPath (Get-CopyPath $copy 'ROADMAP.md')
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'hardening check failed'
            $r.Output | Should -Match ([regex]::Escape('Missing required file: ROADMAP.md'))
        }

        It 'reports the same failure as JSON with -Json' {
            $copy = Copy-RepoToTestDrive
            Remove-Item -LiteralPath (Get-CopyPath $copy 'ROADMAP.md')
            $r = Invoke-Checker $copy -Json
            $r.ExitCode | Should -Be 1
            $result = $r.Output | ConvertFrom-Json
            $result.ok | Should -BeFalse
            $result.strict | Should -BeFalse
            $result.error_count | Should -Be @($result.errors).Count
            $result.errors | Should -Contain 'Missing required file: ROADMAP.md'
        }

        It 'reports invalid JSON in a control file' {
            $copy = Copy-RepoToTestDrive
            [System.IO.File]::WriteAllText((Get-CopyPath $copy 'meta-agent-os/00_control/RUN_MODES.json'), '{ broken')
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match ([regex]::Escape('Invalid JSON in meta-agent-os/00_control/RUN_MODES.json'))
        }

        It 'reports RUN_MODES.json without modes' {
            $copy = Copy-RepoToTestDrive
            [System.IO.File]::WriteAllText((Get-CopyPath $copy 'meta-agent-os/00_control/RUN_MODES.json'), '{ "version": "0.6.1" }')
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'RUN_MODES.json does not define modes.'
        }

        It 'reports a duplicate stage in STAGE_MANIFEST' {
            $copy = Copy-RepoToTestDrive
            Edit-JsonFile $copy 'meta-agent-os/00_control/STAGE_MANIFEST.json' {
                param($d) $d.stages = @($d.stages) + @($d.stages[0])
            }
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'Duplicate stage in STAGE_MANIFEST: Oracle'
        }

        It 'reports a completed stage that the manifest does not know' {
            $copy = Copy-RepoToTestDrive
            Edit-JsonFile $copy 'meta-agent-os/00_control/STAGE_STATE.json' {
                param($d) $d.completed_stages = @($d.completed_stages) + @('Ghost')
            }
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'STAGE_STATE completed_stages contains unknown stage: Ghost'
        }

        It 'reports STAGE_STATE.md drifting from STAGE_STATE.json' {
            $copy = Copy-RepoToTestDrive
            [System.IO.File]::WriteAllText((Get-CopyPath $copy 'meta-agent-os/00_control/STAGE_STATE.md'), "# STAGE_STATE.md`n")
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match "STAGE_STATE.md out of sync: current_stage 'Complete'"
        }

        It 'reports an adapter file missing a Meta Agent OS marker' {
            $copy = Copy-RepoToTestDrive
            [System.IO.File]::WriteAllText((Get-CopyPath $copy 'CODEX_RUNBOOK.md'), "# Runbook`n`nMeta Agent OS, Oracle and Evaluator only.`n")
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'CODEX_RUNBOOK.md missing expected Meta Agent OS marker: Guardian'
        }

        It 'reports a README reference to a meta-agent-os folder that does not exist' {
            $copy = Copy-RepoToTestDrive
            Add-ToFile $copy 'README.md' 'See meta-agent-os/99_ghost for more.'
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'README documents meta-agent-os/99_ghost but that directory does not exist.'
        }

        It 'reports a possible email leak' {
            $copy = Copy-RepoToTestDrive
            $address = 'jane.doe' + '@' + 'leaky-domain.io'
            Add-ToFile $copy 'docs/WHY.md' "Contact $address for access."
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match ([regex]::Escape("Possible email leak in docs/WHY.md: $address"))
        }

        It 'allows documented example addresses' {
            $copy = Copy-RepoToTestDrive
            Add-ToFile $copy 'docs/WHY.md' ('Write to someone' + '@' + 'example.com for help.')
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 0
        }

        It 'reports a possible local path leak' {
            $copy = Copy-RepoToTestDrive
            $leak = 'C:' + '\' + 'Users' + '\' + 'jane' + '\' + 'secret-notes'
            Add-ToFile $copy 'docs/WHY.md' "Files live in $leak today."
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match ([regex]::Escape("Possible local path leak in docs/WHY.md: $leak"))
        }

        It 'reports a pricing entry with no source and an old verification date' {
            $copy = Copy-RepoToTestDrive
            $old = (Get-Date).Date.AddDays(-400).ToString('yyyy-MM-dd')
            Edit-JsonFile $copy 'meta-agent-os/00_control/economics/MODEL_PRICING.json' {
                param($d) $d.models = @([pscustomobject]@{ id = 'demo-model'; input = 1.0; output = 2.0; verified_on = $old })
            }.GetNewClosure()
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match "MODEL_PRICING.json entry 'demo-model' has no 'source'"
            $r.Output | Should -Match "MODEL_PRICING.json entry 'demo-model' was verified 400 days ago, exceeding max_age_days=90"
        }

        It 'reports a pricing entry dated in the future and a non-numeric rate' {
            $copy = Copy-RepoToTestDrive
            $future = (Get-Date).Date.AddDays(10).ToString('yyyy-MM-dd')
            Edit-JsonFile $copy 'meta-agent-os/00_control/economics/MODEL_PRICING.json' {
                param($d) $d.models = @([pscustomobject]@{ id = 'demo-model'; input = 'cheap'; output = 2.0; verified_on = $future; source = 'https://vendor.example/pricing' })
            }.GetNewClosure()
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match "entry 'demo-model' has a non-numeric 'input' rate"
            $r.Output | Should -Match "entry 'demo-model' is dated in the future"
        }

        It 'accepts a fresh, sourced pricing entry' {
            $copy = Copy-RepoToTestDrive
            $today = (Get-Date).Date.ToString('yyyy-MM-dd')
            Edit-JsonFile $copy 'meta-agent-os/00_control/economics/MODEL_PRICING.json' {
                param($d) $d.models = @([pscustomobject]@{ id = 'demo-model'; input = 1.5; output = 2; verified_on = $today; source = 'https://vendor.example/pricing' })
            }.GetNewClosure()
            $r = Invoke-Checker $copy
            $r.ExitCode | Should -Be 0
        }
    }

    Context 'strict-only checks' {
        It 'reports a broken relative Markdown link only in strict mode' {
            $copy = Copy-RepoToTestDrive
            Add-ToFile $copy 'docs/WHY.md' 'See [the missing page](./NOT_A_REAL_PAGE.md).'
            (Invoke-Checker $copy).ExitCode | Should -Be 0
            $r = Invoke-Checker $copy -Strict
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match ([regex]::Escape('Broken relative link in docs/WHY.md: ./NOT_A_REAL_PAGE.md'))
        }

        It 'ignores external links and in-page anchors' {
            $copy = Copy-RepoToTestDrive
            Add-ToFile $copy 'docs/WHY.md' 'See [site](https://vendor.example/x) and [top](#why).'
            (Invoke-Checker $copy -Strict).ExitCode | Should -Be 0
        }

        It 'reports a version mismatch across control files' {
            $copy = Copy-RepoToTestDrive
            Edit-JsonFile $copy 'meta-agent-os/00_control/RUN_MODES.json' { param($d) $d.version = '9.9.9' }
            (Invoke-Checker $copy).ExitCode | Should -Be 0
            $r = Invoke-Checker $copy -Strict
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'Version mismatch across control files:.*RUN_MODES.json=9.9.9'
        }

        It 'reports an unresolved placeholder in a public doc' {
            $copy = Copy-RepoToTestDrive
            Add-ToFile $copy 'INSTALL.md' ('TO' + 'DO: finish this section.')
            (Invoke-Checker $copy).ExitCode | Should -Be 0
            $r = Invoke-Checker $copy -Strict
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'Strict mode: unresolved placeholder in INSTALL.md'
        }

        It 'reports a completed stage output that lost a required section' {
            $copy = Copy-RepoToTestDrive
            $path = Get-CopyPath $copy 'meta-agent-os/03_outputs/diagnosis/ORACLE_DIAGNOSIS.md'
            $content = [System.IO.File]::ReadAllText($path)
            [System.IO.File]::WriteAllText($path, ($content -replace '(?mi)^(#+\s*(?:\d+\.\s*)?)Open Questions\s*$', '$1Questions Parked'))
            $r = Invoke-Checker $copy -Strict
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match "Stage output 'Oracle' missing required section from schema: Open Questions"
        }
    }
}
