#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

# $errors is assigned in BeforeEach and read by the dot-sourced helpers through
# PowerShell's dynamic scoping, which the analyzer cannot see.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Read by dot-sourced helpers via dynamic scope.')]
param()

# Unit tests for the helper functions in scripts/check-meta-agent-os.ps1.
# The script is dot-sourced; its guard stops before the check itself runs, so
# only the helpers load. Each test points $root at a scratch folder in
# $TestDrive and collects messages in a fresh $errors list, which is how the
# helpers report problems.
#
# The checker makes no network or process calls. Those cmdlets are mocked to
# throw anyway, so a future change that adds one fails here first.
#
# Note: this file is itself scanned by the checker's leak scan, so it never
# spells out an email address or a home-directory path literally.

BeforeAll {
    $script:CheckerPath = [System.IO.Path]::Combine($PSScriptRoot, '..', 'scripts', 'check-meta-agent-os.ps1')
    . $script:CheckerPath

    function Write-FixtureFile {
        param(
            [string]$RelativePath,
            [string]$Content = ''
        )
        $full = [System.IO.Path]::Combine([string[]](@($root) + ($RelativePath -split "/")))
        New-Item -ItemType Directory -Path (Split-Path -Parent $full) -Force | Out-Null
        [System.IO.File]::WriteAllText($full, $Content)
        return $full
    }

    # Prose long enough to clear the 80-character substance floor.
    $script:LongProse = 'This section explains the reasoning in enough detail that a reviewer can follow it without guessing at intent.'
}

Describe 'check-meta-agent-os helpers' {
    BeforeEach {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $root | Out-Null
        $errors = New-Object System.Collections.Generic.List[string]

        Mock Invoke-RestMethod { throw 'Network call attempted in a unit test.' }
        Mock Invoke-WebRequest { throw 'Network call attempted in a unit test.' }
        Mock Start-Process { throw 'Process launch attempted in a unit test.' }
    }

    Context 'dot-sourcing' {
        It 'loads the helpers without running the check or exiting' {
            Get-Command Get-SectionBodies, Test-StageOutputSections, Test-SuitabilityAssessment -CommandType Function |
                Should -HaveCount 3
        }
    }

    Context 'Resolve-RepoPath' {
        It 'resolves a repo-absolute path (leading slash) under the root' {
            $file = Write-FixtureFile 'meta-agent-os/00_control/X.md' 'x'
            Test-Path -LiteralPath (Resolve-RepoPath '/meta-agent-os/00_control/X.md') | Should -BeTrue
            (Resolve-Path -LiteralPath (Resolve-RepoPath '/meta-agent-os/00_control/X.md')).Path | Should -Be (Resolve-Path -LiteralPath $file).Path
        }

        It 'resolves a relative path the same way' {
            Write-FixtureFile 'docs/A.md' 'a' | Out-Null
            Test-Path -LiteralPath (Resolve-RepoPath 'docs/A.md') | Should -BeTrue
        }

        It 'starts the resolved path with the root' {
            (Resolve-RepoPath '/README.md').StartsWith($root) | Should -BeTrue
        }
    }

    Context 'Test-RequiredPath' {
        It 'returns true and records nothing for an existing file' {
            Write-FixtureFile 'README.md' 'hi' | Out-Null
            Test-RequiredPath 'README.md' | Should -BeTrue
            $errors | Should -HaveCount 0
        }

        It 'returns false and records the kind for a missing path' {
            Test-RequiredPath 'docs/missing' 'directory' | Should -BeFalse
            $errors | Should -Contain 'Missing required directory: docs/missing'
        }
    }

    Context 'Read-JsonFile' {
        It 'parses a valid JSON file' {
            Write-FixtureFile 'a.json' '{ "version": "1.2.3", "modes": ["x"] }' | Out-Null
            $data = Read-JsonFile 'a.json'
            $data.version | Should -Be '1.2.3'
            $errors | Should -HaveCount 0
        }

        It 'returns null and records a missing file' {
            Read-JsonFile 'nope.json' | Should -BeNullOrEmpty
            $errors | Should -Contain 'Missing JSON file: nope.json'
        }

        It 'returns null and records invalid JSON' {
            Write-FixtureFile 'bad.json' '{ not json' | Out-Null
            Read-JsonFile 'bad.json' | Should -BeNullOrEmpty
            $errors[0] | Should -BeLike 'Invalid JSON in bad.json:*'
        }
    }

    Context 'Get-RequiredSections' {
        It 'reads numbered section names from a schema' {
            Write-FixtureFile 'schema.md' "# Schema`n`nRequired sections:`n`n1. Executive Summary`n2. Risks  `n10. Open Questions`n`n- not a section`n" | Out-Null
            $sections = @(Get-RequiredSections 'schema.md')
            $sections | Should -Be @('Executive Summary', 'Risks', 'Open Questions')
        }

        It 'returns nothing for a missing schema' {
            @(Get-RequiredSections 'missing.md') | Should -HaveCount 0
        }
    }

    Context 'Get-SectionBodies' {
        It 'returns the body under a matching heading, case-insensitively' {
            $content = "# Doc`n`n## Risks`n`n- one`n- two`n`n## Next`n`nother"
            $bodies = @(Get-SectionBodies $content 'risks')
            $bodies | Should -HaveCount 1
            $bodies[0] | Should -Be "- one`n- two"
        }

        It 'ignores a leading number on the heading' {
            $bodies = @(Get-SectionBodies "## 3. Open Questions`n`n- why?" 'Open Questions')
            $bodies[0] | Should -Be '- why?'
        }

        It 'keeps deeper subheadings inside the body and stops at a same-level heading' {
            $content = "## Risks`nintro`n### Detail`nmore`n## After`nnot included"
            $body = @(Get-SectionBodies $content 'Risks')[0]
            $body | Should -Match '### Detail'
            $body | Should -Not -Match 'not included'
        }

        It 'returns every occurrence of a repeated section' {
            @(Get-SectionBodies "## Risks`na`n## Other`nb`n## Risks`nc" 'Risks') | Should -Be @('a', 'c')
        }

        It 'returns nothing when the section is absent' {
            @(Get-SectionBodies "## Something`ntext" 'Risks') | Should -HaveCount 0
        }
    }

    Context 'Test-EnumeratedItem' {
        It 'accepts <Name>' -ForEach @(
            @{ Name = 'a dash bullet'; Body = "Intro`n- item" }
            @{ Name = 'a star bullet'; Body = '* item' }
            @{ Name = 'a plus bullet'; Body = '+ item' }
            @{ Name = 'a numbered item'; Body = '1. item' }
            @{ Name = 'a table row'; Body = '| a | b |' }
        ) {
            Test-EnumeratedItem $Body | Should -BeTrue
        }

        It 'rejects <Name>' -ForEach @(
            @{ Name = 'a narrative sentence'; Body = 'There are some risks, mostly minor.' }
            @{ Name = 'an empty bullet'; Body = '- ' }
            @{ Name = 'a hyphenated word'; Body = 'well-known risks' }
        ) {
            Test-EnumeratedItem $Body | Should -BeFalse
        }
    }

    Context 'Test-IsNumber and Test-IsPositiveInteger' {
        It 'Test-IsNumber is <Expected> for <Label>' -ForEach @(
            @{ Label = 'int 5'; Value = 5; Expected = $true }
            @{ Label = 'long'; Value = [long]5; Expected = $true }
            @{ Label = 'double 2.5'; Value = 2.5; Expected = $true }
            @{ Label = 'decimal'; Value = [decimal]1.25; Expected = $true }
            @{ Label = 'string 5'; Value = '5'; Expected = $false }
            @{ Label = 'bool'; Value = $true; Expected = $false }
            @{ Label = 'null'; Value = $null; Expected = $false }
        ) {
            Test-IsNumber $Value | Should -Be $Expected
        }

        It 'Test-IsPositiveInteger is <Expected> for <Label>' -ForEach @(
            @{ Label = '90'; Value = 90; Expected = $true }
            @{ Label = '3.0'; Value = 3.0; Expected = $true }
            @{ Label = '0'; Value = 0; Expected = $false }
            @{ Label = '-1'; Value = -1; Expected = $false }
            @{ Label = '2.5'; Value = 2.5; Expected = $false }
            @{ Label = 'string 90'; Value = '90'; Expected = $false }
            @{ Label = 'null'; Value = $null; Expected = $false }
        ) {
            Test-IsPositiveInteger $Value | Should -Be $Expected
        }

        It 'treats JSON-deserialised numbers as numbers on this PowerShell edition' {
            $data = '{ "i": 90, "d": 0.5, "big": 12345678901 }' | ConvertFrom-Json
            Test-IsPositiveInteger $data.i | Should -BeTrue
            Test-IsNumber $data.d | Should -BeTrue
            Test-IsPositiveInteger $data.big | Should -BeTrue
        }
    }

    Context 'Test-StageOutputSections' {
        BeforeEach {
            Write-FixtureFile 'schema.md' "1. Summary`n2. Risks`n" | Out-Null
        }

        It 'records nothing for a complete output' {
            Write-FixtureFile 'out.md' "## Summary`n`n$LongProse`n`n## Risks`n`n- a real risk`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 0
        }

        It 'does nothing when the output file does not exist' {
            Test-StageOutputSections 'Oracle' 'missing.md' 'schema.md'
            $errors | Should -HaveCount 0
        }

        It 'records a missing required section' {
            Write-FixtureFile 'out.md' "## Summary`n`n$LongProse`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -Contain "Stage output 'Oracle' missing required section from schema: Risks"
        }

        It 'requires enumerated sections to be a list or table' {
            Write-FixtureFile 'out.md' "## Summary`n`n$LongProse`n`n## Risks`n`nThere are a few risks, described here in a single narrative sentence that is long enough.`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 1
            $errors[0] | Should -BeLike "Stage output 'Oracle' section 'Risks' must enumerate entries*"
        }

        It 'requires prose sections to clear the length floor' {
            Write-FixtureFile 'out.md' "## Summary`n`nToo short.`n`n## Risks`n`n- r`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 1
            $errors[0] | Should -BeLike "*section 'Summary' has no substantive content*80 non-whitespace characters*"
        }

        It 'accepts a short prose section when it is a list' {
            Write-FixtureFile 'out.md' "## Summary`n`n- short`n`n## Risks`n`n- r`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 0
        }

        It 'flags an unresolved placeholder in prose' {
            Write-FixtureFile 'out.md' "## Summary`n`n$LongProse TBD.`n`n## Risks`n`n- r`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -Contain "Stage output 'Oracle' section 'Summary' contains an unresolved placeholder: TBD"
        }

        It 'ignores placeholder tokens inside code spans and fences' {
            $fence = '```'
            Write-FixtureFile 'out.md' "## Summary`n`n$LongProse Mention ``TODO`` as a token.`n`n$fence`nFIXME`n$fence`n`n## Risks`n`n- r`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 0
        }

        It 'accepts a section when any repeated occurrence is substantive' {
            Write-FixtureFile 'out.md' "## Summary`n`nshort`n`n## Risks`n`n- r`n`n## Summary`n`n$LongProse`n" | Out-Null
            Test-StageOutputSections 'Oracle' 'out.md' 'schema.md'
            $errors | Should -HaveCount 0
        }
    }

    Context 'Test-StageOutputMetadata' {
        It 'records nothing for a dated output with a status on or before the state date' {
            Write-FixtureFile 'out.md' "# Out`n`n**Date:** 2026-08-01`n**Status:** Complete`n" | Out-Null
            Test-StageOutputMetadata 'Oracle' 'out.md' '2026-08-04'
            $errors | Should -HaveCount 0
        }

        It 'accepts CRLF line endings' {
            Write-FixtureFile 'out.md' "# Out`r`n`r`n**Date:** 2026-08-01`r`n**Status:** Complete`r`n" | Out-Null
            Test-StageOutputMetadata 'Oracle' 'out.md' '2026-08-04'
            $errors | Should -HaveCount 0
        }

        It 'records a missing date and status' {
            Write-FixtureFile 'out.md' "# Out`n`nNo metadata here.`n" | Out-Null
            Test-StageOutputMetadata 'Oracle' 'out.md' '2026-08-04'
            $errors | Should -Contain "Stage output 'Oracle' is missing a '**Date:** YYYY-MM-DD' metadata line."
            $errors | Should -Contain "Stage output 'Oracle' is missing a '**Status:**' metadata line."
        }

        It 'records state that is older than its own output' {
            Write-FixtureFile 'out.md' "**Date:** 2026-09-01`n**Status:** Complete`n" | Out-Null
            Test-StageOutputMetadata 'Oracle' 'out.md' '2026-08-04'
            $errors | Should -HaveCount 1
            $errors[0] | Should -BeLike "*dated 2026-09-01 but STAGE_STATE.json last_updated is 2026-08-04*"
        }

        It 'does nothing when the output file does not exist' {
            Test-StageOutputMetadata 'Oracle' 'missing.md' '2026-08-04'
            $errors | Should -HaveCount 0
        }
    }

    Context 'Test-SuitabilityAssessment' {
        BeforeAll {
            function Get-AssessmentJson {
                param([hashtable]$Overrides = @{})
                $gate = [ordered]@{}
                foreach ($c in @('requires_judgement', 'unstructured_inputs', 'imperfect_answer_useful', 'human_can_recover')) {
                    $gate[$c] = [ordered]@{ holds = $true; reason = "Because $c." }
                }
                $data = [ordered]@{ gate = $gate; scores = [ordered]@{ judgement = 4 } }
                foreach ($k in $Overrides.Keys) { $data[$k] = $Overrides[$k] }
                return ($data | ConvertTo-Json -Depth 6)
            }
        }

        It 'does nothing when the stage has no assessment file' {
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ name = 'Oracle' })
            $errors | Should -HaveCount 0
        }

        It 'records nothing for a complete assessment' {
            Write-FixtureFile 'a.json' (Get-AssessmentJson) | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -HaveCount 0
        }

        It 'records a missing assessment file' {
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'missing.json' })
            $errors | Should -Contain "Stage 'Oracle' is complete but its required assessment file is missing: missing.json"
        }

        It 'records invalid JSON' {
            Write-FixtureFile 'a.json' '{ nope' | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors[0] | Should -BeLike "Invalid JSON in assessment file for stage 'Oracle' (a.json):*"
        }

        It 'records a missing gate object' {
            Write-FixtureFile 'a.json' '{ "scores": { "x": 1 } }' | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -Contain "Assessment file for stage 'Oracle' (a.json) has no 'gate' object."
        }

        It 'records a gate condition answered without a boolean' {
            $json = Get-AssessmentJson | ConvertFrom-Json
            $json.gate.human_can_recover.holds = 'yes'
            Write-FixtureFile 'a.json' ($json | ConvertTo-Json -Depth 6) | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -Contain "Assessment file for stage 'Oracle' (a.json) does not answer gate condition 'human_can_recover' with a boolean 'holds' field."
        }

        It 'records a gate condition without a reason' {
            $json = Get-AssessmentJson | ConvertFrom-Json
            $json.gate.requires_judgement.reason = ''
            Write-FixtureFile 'a.json' ($json | ConvertTo-Json -Depth 6) | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -Contain "Assessment file for stage 'Oracle' (a.json) answers gate condition 'requires_judgement' without a 'reason'."
        }

        It 'accepts a gate condition that does not hold, as long as it is answered' {
            $json = Get-AssessmentJson | ConvertFrom-Json
            $json.gate.unstructured_inputs.holds = $false
            Write-FixtureFile 'a.json' ($json | ConvertTo-Json -Depth 6) | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -HaveCount 0
        }

        It 'records empty scores' {
            Write-FixtureFile 'a.json' (Get-AssessmentJson -Overrides @{ scores = @{} }) | Out-Null
            Test-SuitabilityAssessment 'Oracle' ([pscustomobject]@{ assessment_file = 'a.json' })
            $errors | Should -Contain "Assessment file for stage 'Oracle' (a.json) has no 'scores' object."
        }
    }
}
