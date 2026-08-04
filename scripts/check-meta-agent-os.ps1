param(
    [switch]$Strict,
    [switch]$Json
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$errors = New-Object System.Collections.Generic.List[string]

function Add-Error {
    param([string]$Message)
    $errors.Add($Message)
}

function Resolve-RepoPath {
    param([string]$Path)
    $normalized = $Path -replace '/', '\'
    $normalized = $normalized.TrimStart('\')
    return Join-Path $root $normalized
}

function Test-RequiredPath {
    param(
        [string]$Path,
        [string]$Kind = "file"
    )

    $resolved = Resolve-RepoPath $Path
    if (-not (Test-Path -LiteralPath $resolved)) {
        Add-Error "Missing required $Kind`: $Path"
        return $false
    }
    return $true
}

function Read-JsonFile {
    param([string]$Path)

    $resolved = Resolve-RepoPath $Path
    if (-not (Test-Path -LiteralPath $resolved)) {
        Add-Error "Missing JSON file: $Path"
        return $null
    }

    try {
        return Get-Content -Raw -LiteralPath $resolved | ConvertFrom-Json
    }
    catch {
        Add-Error "Invalid JSON in $Path`: $($_.Exception.Message)"
        return $null
    }
}

function Get-RequiredSections {
    param([string]$SchemaPath)

    $resolved = Resolve-RepoPath $SchemaPath
    if (-not (Test-Path -LiteralPath $resolved)) {
        return @()
    }

    $sections = New-Object System.Collections.Generic.List[string]
    foreach ($line in Get-Content -LiteralPath $resolved) {
        if ($line -match '^\s*\d+\.\s+(.+?)\s*$') {
            $sections.Add($Matches[1])
        }
    }
    return $sections
}

# Sections that must enumerate their content rather than gesture at it.
$script:EnumeratedSections = @(
    "assumptions",
    "risks",
    "open questions",
    "files created or updated"
)

# Minimum non-whitespace characters of body text under a required prose section.
$script:MinSectionChars = 80

$script:PlaceholderPattern = '\bTBD\b|\bTODO\b|\bFIXME\b|\bXXX\b|lorem ipsum|\{\{[^}]*\}\}|<placeholder'

function Get-SectionBodies {
    param(
        [string]$Content,
        [string]$Section
    )

    $headings = [regex]::Matches($Content, '(?m)^(#{1,6})[ \t]+(.*?)[ \t]*$')
    $normalized = $Section.Trim().ToLowerInvariant()
    $bodies = New-Object System.Collections.Generic.List[string]

    for ($i = 0; $i -lt $headings.Count; $i++) {
        $level = $headings[$i].Groups[1].Value.Length
        $title = ($headings[$i].Groups[2].Value -replace '^\d+\.\s*', '').Trim().ToLowerInvariant()
        if ($title -ne $normalized) { continue }

        $start = $headings[$i].Index + $headings[$i].Length
        $stop = $Content.Length
        for ($j = $i + 1; $j -lt $headings.Count; $j++) {
            if ($headings[$j].Groups[1].Value.Length -le $level) {
                $stop = $headings[$j].Index
                break
            }
        }
        $bodies.Add($Content.Substring($start, $stop - $start).Trim())
    }

    return $bodies
}

function Test-EnumeratedItem {
    param([string]$Body)
    return [bool]([regex]::IsMatch($Body, '(?m)^\s*(?:[-*+]\s+\S|\d+\.\s+\S|\|)'))
}

# Windows PowerShell 5.1 and PowerShell 7 deserialize JSON numbers to different
# CLR types (int vs long, double vs decimal). Test the value, not its type.
function Test-IsNumber {
    param($Value)
    if ($null -eq $Value) { return $false }
    if ($Value -is [string] -or $Value -is [bool]) { return $false }
    return ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or
            $Value -is [decimal] -or $Value -is [single] -or $Value -is [byte] -or $Value -is [int16])
}

function Test-IsPositiveInteger {
    param($Value)
    if (-not (Test-IsNumber $Value)) { return $false }
    $asDouble = [double]$Value
    return ($asDouble -gt 0 -and $asDouble -eq [math]::Floor($asDouble))
}

function Test-StageOutputSections {
    param(
        [string]$StageName,
        [string]$OutputPath,
        [string]$SchemaPath
    )

    $outputResolved = Resolve-RepoPath $OutputPath
    if (-not (Test-Path -LiteralPath $outputResolved)) {
        return
    }

    $content = Get-Content -Raw -LiteralPath $outputResolved
    foreach ($section in Get-RequiredSections $SchemaPath) {
        $bodies = Get-SectionBodies $content $section
        if ($bodies.Count -eq 0) {
            Add-Error "Stage output '$StageName' missing required section from schema: $section"
            continue
        }

        # A section may legitimately appear more than once (for example, a schema
        # alignment addendum). Accept the stage if any occurrence carries substance.
        # Enumerated sections are judged on having entries; a one-line list is complete.
        # Prose sections are judged on length, since a single clause is not an analysis.
        if ($script:EnumeratedSections -contains $section.Trim().ToLowerInvariant()) {
            $substantive = @($bodies | Where-Object { Test-EnumeratedItem $_ })
            if ($substantive.Count -eq 0) {
                Add-Error "Stage output '$StageName' section '$section' must enumerate entries as a list or table, not a single narrative sentence."
                continue
            }
        }
        else {
            # A list or table is self-evidently content regardless of length. Only
            # pure prose has to clear the length bar.
            $substantive = @($bodies | Where-Object {
                (Test-EnumeratedItem $_) -or (($_ -replace '\s', '').Length -ge $script:MinSectionChars)
            })
            if ($substantive.Count -eq 0) {
                Add-Error "Stage output '$StageName' section '$section' has no substantive content (needs a list, a table, or at least $($script:MinSectionChars) non-whitespace characters)."
                continue
            }
        }

        foreach ($body in $substantive) {
            # Placeholder tokens inside code spans or fences are being discussed,
            # not left behind. Strip them before scanning.
            $prose = [regex]::Replace($body, '```.*?```', ' ', [System.Text.RegularExpressions.RegexOptions]::Singleline)
            $prose = [regex]::Replace($prose, '`[^`]*`', ' ')
            $placeholder = [regex]::Match($prose, $script:PlaceholderPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            if ($placeholder.Success) {
                Add-Error "Stage output '$StageName' section '$section' contains an unresolved placeholder: $($placeholder.Value)"
                break
            }
        }
    }
}

function Test-StageOutputMetadata {
    param(
        [string]$StageName,
        [string]$OutputPath,
        [string]$StateUpdated
    )

    $outputResolved = Resolve-RepoPath $OutputPath
    if (-not (Test-Path -LiteralPath $outputResolved)) {
        return
    }

    $content = Get-Content -Raw -LiteralPath $outputResolved

    # `\r?` keeps these anchored correctly when the file is checked out with CRLF endings.
    $dateMatch = [regex]::Match($content, '(?m)^\*\*Date:\*\*[ \t]*(\d{4}-\d{2}-\d{2})[ \t]*\r?$')
    if (-not $dateMatch.Success) {
        Add-Error "Stage output '$StageName' is missing a '**Date:** YYYY-MM-DD' metadata line."
    }
    if (-not [regex]::IsMatch($content, '(?m)^\*\*Status:\*\*[ \t]*\S')) {
        Add-Error "Stage output '$StageName' is missing a '**Status:**' metadata line."
    }

    if ($dateMatch.Success -and $StateUpdated) {
        if ([string]::Compare($dateMatch.Groups[1].Value, $StateUpdated, [System.StringComparison]::Ordinal) -gt 0) {
            Add-Error "Stage output '$StageName' is dated $($dateMatch.Groups[1].Value) but STAGE_STATE.json last_updated is $StateUpdated. State is stale relative to its own output."
        }
    }
}

$requiredFiles = @(
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX_RUNBOOK.md",
    "META_AGENT_BOOTSTRAP.md",
    "INSTALL.md",
    "ROADMAP.md",
    "docs/PUBLIC_BOUNDARY.md",
    "docs/RELEASE_CHECKLIST.md",
    "docs/RUNTIME_TRACK.md",
    "docs/WHY.md",
    "docs/examples/WORKED_EXAMPLE_SUPPORT_TRIAGE.md",
    "docs/examples/WORKED_EXAMPLE_RESEARCH_ASSISTANT.md",
    "LICENSE",
    ".claude/commands/mao-status.md",
    ".claude/commands/mao-diagnose.md",
    ".claude/commands/mao-resume.md",
    ".claude/commands/mao-validate.md",
    ".claude/commands/mao-harden.md",
    ".claude/commands/mao-memory.md",
    ".claude/commands/mao-export-pack.md",
    "CONTRIBUTING.md",
    "SECURITY.md",
    "CODE_OF_CONDUCT.md",
    ".github/pull_request_template.md",
    ".github/workflows/meta-agent-os.yml",
    ".github/ISSUE_TEMPLATE/bug_report.yml",
    ".github/ISSUE_TEMPLATE/feature_request.yml",
    ".github/ISSUE_TEMPLATE/config.yml",
    "meta-agent-os/00_control/AGENT_MANIFEST.md",
    "meta-agent-os/00_control/OUTPUT_MANIFEST.json",
    "meta-agent-os/00_control/QUALITY_BAR.md",
    "meta-agent-os/00_control/RESUME_PROTOCOL.md",
    "meta-agent-os/00_control/RUN_META_AGENT_OS.md",
    "meta-agent-os/00_control/RUN_MODES.json",
    "meta-agent-os/00_control/STAGE_ADVANCEMENT_PROTOCOL.md",
    "meta-agent-os/00_control/STAGE_GATES.md",
    "meta-agent-os/00_control/STAGE_MANIFEST.json",
    "meta-agent-os/00_control/STAGE_STATE.json",
    "meta-agent-os/00_control/STAGE_STATE.md",
    "meta-agent-os/00_control/JSON_STATE_UPDATE_PROTOCOL.md",
    "meta-agent-os/00_control/validators/GLOBAL_STAGE_VALIDATOR.md",
    "meta-agent-os/00_control/economics/MODEL_PRICING.json",
    "meta-agent-os/00_control/economics/TOKEN_BUDGET_TEMPLATE.md",
    "meta-agent-os/00_control/economics/ROI_METHOD.md",
    "scripts/roi-calculator.py",
    "docs/examples/roi/EXAMPLE_WORKFLOW.json",
    "docs/examples/roi/EXAMPLE_PRICING.json",
    "meta-agent-os/05_memory/project_brain.md",
    "meta-agent-os/05_memory/decision_log.md",
    "meta-agent-os/05_memory/assumptions_log.md",
    "meta-agent-os/05_memory/changelog.md",
    "skills/meta-agent-os/SKILL.md",
    "skills/meta-agent-os/references/stage-lifecycle.md",
    "skills/meta-agent-os/references/output-standard.md"
)

$requiredDirectories = @(
    "meta-agent-os/00_control/codex",
    "meta-agent-os/00_control/schemas",
    "meta-agent-os/00_control/validators",
    "meta-agent-os/03_outputs/diagnosis",
    "meta-agent-os/03_outputs/research",
    "meta-agent-os/03_outputs/maps",
    "meta-agent-os/03_outputs/architecture",
    "meta-agent-os/03_outputs/costs",
    "meta-agent-os/03_outputs/risk",
    "meta-agent-os/03_outputs/build",
    "meta-agent-os/03_outputs/evals",
    "meta-agent-os/03_outputs/runtime",
    "meta-agent-os/05_memory",
    "skills/meta-agent-os",
    "skills/meta-agent-os/references",
    "docs/examples"
)

foreach ($file in $requiredFiles) {
    Test-RequiredPath $file "file" | Out-Null
}

foreach ($dir in $requiredDirectories) {
    Test-RequiredPath $dir "directory" | Out-Null
}

$stageManifest = Read-JsonFile "meta-agent-os/00_control/STAGE_MANIFEST.json"
$stageState = Read-JsonFile "meta-agent-os/00_control/STAGE_STATE.json"
$outputManifest = Read-JsonFile "meta-agent-os/00_control/OUTPUT_MANIFEST.json"
$runModes = Read-JsonFile "meta-agent-os/00_control/RUN_MODES.json"

if ($null -ne $stageManifest -and $null -ne $stageManifest.stages) {
    $stageNames = @()
    foreach ($stage in $stageManifest.stages) {
        if (-not $stage.name) { Add-Error "STAGE_MANIFEST contains a stage without a name." }
        if ($stageNames -contains $stage.name) { Add-Error "Duplicate stage in STAGE_MANIFEST: $($stage.name)" }
        $stageNames += $stage.name

        foreach ($field in @("output", "schema", "validator")) {
            if (-not $stage.$field) {
                Add-Error "Stage '$($stage.name)' is missing field '$field' in STAGE_MANIFEST."
                continue
            }

            if ($field -eq "output") {
                $parent = Split-Path -Parent (Resolve-RepoPath $stage.$field)
                if (-not (Test-Path -LiteralPath $parent)) {
                    Add-Error "Output parent directory does not exist for stage '$($stage.name)': $($stage.output)"
                }
            }
            else {
                Test-RequiredPath $stage.$field $field | Out-Null
            }
        }
    }
}

if ($null -ne $outputManifest) {
    foreach ($file in $outputManifest.required_memory_files) {
        Test-RequiredPath $file "memory file" | Out-Null
    }
    foreach ($dir in $outputManifest.required_output_directories) {
        Test-RequiredPath $dir "output directory" | Out-Null
    }
}

if ($null -ne $stageState -and $null -ne $stageManifest) {
    $knownStages = @($stageManifest.stages | ForEach-Object { $_.name })

    if ($stageState.status -eq "complete" -and $stageState.current_stage -eq "Complete") {
        # Completed runs use a terminal current_stage outside STAGE_MANIFEST.
    }
    elseif ($knownStages -notcontains $stageState.current_stage) {
        Add-Error "STAGE_STATE current_stage is not in STAGE_MANIFEST: $($stageState.current_stage)"
    }

    foreach ($completedStage in $stageState.completed_stages) {
        if ($knownStages -notcontains $completedStage) {
            Add-Error "STAGE_STATE completed_stages contains unknown stage: $completedStage"
            continue
        }

        $manifestEntry = $stageManifest.stages | Where-Object { $_.name -eq $completedStage } | Select-Object -First 1
        Test-RequiredPath $manifestEntry.output "completed stage output" | Out-Null

        if ($Strict) {
            Test-StageOutputSections $completedStage $manifestEntry.output $manifestEntry.schema
            Test-StageOutputMetadata $completedStage $manifestEntry.output $stageState.last_updated
        }

        if ($null -ne $stageState.stage_status -and $stageState.stage_status.$completedStage -ne "complete") {
            Add-Error "STAGE_STATE completed stage '$completedStage' is not marked complete in stage_status."
        }
    }

    if ($null -ne $stageState.stage_status -and $stageState.status -eq "in_progress") {
        $currentStatus = $stageState.stage_status.($stageState.current_stage)
        if ($currentStatus -ne "in_progress") {
            Add-Error "STAGE_STATE current stage '$($stageState.current_stage)' has status '$currentStatus' but top-level status is in_progress."
        }

        if ($Strict) {
            $currentManifestEntry = $stageManifest.stages | Where-Object { $_.name -eq $stageState.current_stage } | Select-Object -First 1
            if ($null -ne $currentManifestEntry) {
                Test-StageOutputSections $stageState.current_stage $currentManifestEntry.output $currentManifestEntry.schema
            }
        }
    }
}

if ($null -ne $runModes -and -not $runModes.modes) {
    Add-Error "RUN_MODES.json does not define modes."
}

$adapterFiles = @(
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX_RUNBOOK.md"
)

foreach ($file in $adapterFiles) {
    $resolved = Resolve-RepoPath $file
    if (-not (Test-Path -LiteralPath $resolved)) { continue }
    $content = Get-Content -Raw -LiteralPath $resolved
    foreach ($marker in @("Meta Agent OS", "Oracle", "Guardian", "Evaluator")) {
        if ($content -notmatch [regex]::Escape($marker)) {
            Add-Error "$file missing expected Meta Agent OS marker: $marker"
        }
    }
}

$skillContent = Get-Content -Raw -LiteralPath (Resolve-RepoPath "skills/meta-agent-os/SKILL.md") -ErrorAction SilentlyContinue
if ($null -ne $skillContent) {
    foreach ($marker in @("name: meta-agent-os", "description:", "Diagnose before design", "STAGE_STATE.json", "STAGE_MANIFEST.json")) {
        if ($skillContent -notmatch [regex]::Escape($marker)) {
            Add-Error "skills/meta-agent-os/SKILL.md missing expected marker: $marker"
        }
    }
}

if ($Strict) {
    $scanFiles = @(
        "README.md",
        "AGENTS.md",
        "CLAUDE.md",
        "CODEX_RUNBOOK.md",
        "INSTALL.md",
        "ROADMAP.md",
        "docs/PUBLIC_BOUNDARY.md",
        "docs/RELEASE_CHECKLIST.md",
        "docs/RUNTIME_TRACK.md"
    )

    foreach ($file in $scanFiles) {
        $resolved = Resolve-RepoPath $file
        if (-not (Test-Path -LiteralPath $resolved)) { continue }
        $content = Get-Content -Raw -LiteralPath $resolved
        # Code spans and fences name these tokens deliberately; only prose counts.
        $prose = [regex]::Replace($content, '```.*?```', ' ', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $prose = [regex]::Replace($prose, '`[^`]*`', ' ')
        if ($prose -match "TODO:|{{[^}]+}}") {
            Add-Error "Strict mode: unresolved placeholder in $file"
        }
    }
}

# STAGE_STATE.json must stay in sync with its human-readable Markdown mirror.
$stateMdPath = Resolve-RepoPath "meta-agent-os/00_control/STAGE_STATE.md"
if ($null -ne $stageState -and (Test-Path -LiteralPath $stateMdPath)) {
    $stateMd = (Get-Content -Raw -LiteralPath $stateMdPath).ToLowerInvariant()

    if ($stageState.current_stage -and -not $stateMd.Contains(([string]$stageState.current_stage).ToLowerInvariant())) {
        Add-Error "STAGE_STATE.md out of sync: current_stage '$($stageState.current_stage)' from JSON not found in Markdown mirror."
    }
    if ($stageState.status -and -not $stateMd.Contains(([string]$stageState.status).ToLowerInvariant())) {
        Add-Error "STAGE_STATE.md out of sync: status '$($stageState.status)' from JSON not found in Markdown mirror."
    }
    foreach ($completed in $stageState.completed_stages) {
        if (-not $stateMd.Contains(([string]$completed).ToLowerInvariant())) {
            Add-Error "STAGE_STATE.md out of sync: completed stage '$completed' from JSON not found in Markdown mirror."
        }
    }
}

# Pricing registry integrity. Rates are inputs, not constants: an undated or
# unsourced rate produces a confident wrong cost, which is worse than no cost.
# Mirrors the checks in scripts/roi-calculator.py so the two cannot drift apart.
$pricing = Read-JsonFile "meta-agent-os/00_control/economics/MODEL_PRICING.json"
if ($null -ne $pricing) {
    $maxAge = $pricing.max_age_days
    $maxAgeValid = Test-IsPositiveInteger $maxAge
    if (-not $maxAgeValid) {
        Add-Error "MODEL_PRICING.json must set a positive integer 'max_age_days'."
    }
    if ($null -eq $pricing.PSObject.Properties['models']) {
        Add-Error "MODEL_PRICING.json must define a 'models' list (empty is valid)."
    }
    else {
        $today = (Get-Date).Date
        $seenIds = New-Object System.Collections.Generic.HashSet[string]
        $modelIndex = 0
        foreach ($entry in @($pricing.models)) {
            $modelId = $entry.id
            if (-not $modelId) {
                Add-Error "MODEL_PRICING.json entry $modelIndex has no 'id'."
                $modelIndex++
                continue
            }
            if (-not $seenIds.Add([string]$modelId)) {
                Add-Error "MODEL_PRICING.json has a duplicate model id: $modelId"
            }

            foreach ($field in @("input", "output")) {
                if (-not (Test-IsNumber $entry.$field)) {
                    Add-Error "MODEL_PRICING.json entry '$modelId' has a non-numeric '$field' rate."
                }
            }
            if (-not $entry.source) {
                Add-Error "MODEL_PRICING.json entry '$modelId' has no 'source'. An unsourced rate is a guess."
            }

            $verified = [datetime]::MinValue
            if (-not [datetime]::TryParseExact(
                    [string]$entry.verified_on,
                    'yyyy-MM-dd',
                    [System.Globalization.CultureInfo]::InvariantCulture,
                    [System.Globalization.DateTimeStyles]::None,
                    [ref]$verified)) {
                Add-Error "MODEL_PRICING.json entry '$modelId' needs a 'verified_on' ISO date (YYYY-MM-DD), got: $($entry.verified_on)"
                $modelIndex++
                continue
            }

            if ($maxAgeValid) {
                $age = [int]($today - $verified.Date).TotalDays
                if ($age -lt 0) {
                    Add-Error "MODEL_PRICING.json entry '$modelId' is dated in the future: $($verified.ToString('yyyy-MM-dd'))."
                }
                elseif ($age -gt $maxAge) {
                    Add-Error "MODEL_PRICING.json entry '$modelId' was verified $age days ago, exceeding max_age_days=$maxAge. Re-verify against current published pricing rather than raising the threshold."
                }
            }
            $modelIndex++
        }
    }
}

# Relative Markdown links must resolve. Renames are the usual way docs rot.
if ($Strict) {
    $skipDirs = @(".git", "node_modules")
    $markdownFiles = Get-ChildItem -LiteralPath $root -Filter "*.md" -Recurse -File |
        Where-Object {
            $relative = $_.FullName.Substring($root.Length).TrimStart('\', '/')
            $parts = $relative -split '[\\/]'
            -not ($parts | Where-Object { $skipDirs -contains $_ })
        }

    foreach ($mdFile in $markdownFiles) {
        $relFile = ($mdFile.FullName.Substring($root.Length).TrimStart('\', '/')) -replace '\\', '/'
        $mdContent = Get-Content -Raw -LiteralPath $mdFile.FullName
        if ($null -eq $mdContent) { continue }

        foreach ($linkMatch in [regex]::Matches($mdContent, '\[[^\]]*\]\(\s*(<[^>]*>|[^)\s]+)')) {
            $targetRaw = $linkMatch.Groups[1].Value.Trim()
            if ($targetRaw.StartsWith("<") -and $targetRaw.EndsWith(">")) {
                $targetRaw = $targetRaw.Substring(1, $targetRaw.Length - 2)
            }
            if ([string]::IsNullOrWhiteSpace($targetRaw)) { continue }
            if ($targetRaw -match '^(https?://|mailto:|#)') { continue }

            $targetClean = ($targetRaw -split '#', 2)[0].Replace("%20", " ")
            if ([string]::IsNullOrWhiteSpace($targetClean)) { continue }

            if ($targetClean.StartsWith("/")) {
                $resolvedLink = Resolve-RepoPath $targetClean
            }
            else {
                $resolvedLink = Join-Path $mdFile.DirectoryName ($targetClean -replace '/', '\')
            }

            if (-not (Test-Path -LiteralPath $resolvedLink)) {
                Add-Error "Broken relative link in $relFile`: $targetRaw"
            }
        }
    }
}

# README must not document meta-agent-os subdirectories that do not exist.
$readmePath = Resolve-RepoPath "README.md"
if (Test-Path -LiteralPath $readmePath) {
    $readmeContent = Get-Content -Raw -LiteralPath $readmePath
    $readmeSubdirs = New-Object System.Collections.Generic.HashSet[string]
    foreach ($match in [regex]::Matches($readmeContent, '/(\d\d_[a-z_]+)')) {
        [void]$readmeSubdirs.Add($match.Groups[1].Value)
    }
    foreach ($sub in $readmeSubdirs) {
        if (-not (Test-Path -LiteralPath (Resolve-RepoPath "meta-agent-os/$sub"))) {
            Add-Error "README documents meta-agent-os/$sub but that directory does not exist."
        }
    }
}

if ($errors.Count -gt 0) {
    if ($Json) {
        [ordered]@{
            ok = $false
            strict = [bool]$Strict
            error_count = $errors.Count
            errors = @($errors)
        } | ConvertTo-Json -Depth 4
    }
    else {
        Write-Host "Meta Agent OS hardening check failed:" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host " - $error" -ForegroundColor Red
        }
    }
    exit 1
}

if ($Json) {
    [ordered]@{
        ok = $true
        strict = [bool]$Strict
        error_count = 0
        errors = @()
    } | ConvertTo-Json -Depth 4
}
else {
    if ($Strict) {
        Write-Host "Meta Agent OS hardening check passed in strict mode." -ForegroundColor Green
    }
    else {
        Write-Host "Meta Agent OS hardening check passed." -ForegroundColor Green
    }
}

exit 0
