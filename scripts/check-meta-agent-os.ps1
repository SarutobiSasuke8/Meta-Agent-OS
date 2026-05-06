param(
    [switch]$Strict
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

$requiredFiles = @(
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "CODEX_RUNBOOK.md",
    "META_AGENT_BOOTSTRAP.md",
    "INSTALL.md",
    "ROADMAP.md",
    "LICENSE",
    ".claude/commands/mao-status.md",
    ".claude/commands/mao-diagnose.md",
    ".claude/commands/mao-resume.md",
    ".claude/commands/mao-validate.md",
    ".claude/commands/mao-harden.md",
    ".claude/commands/mao-memory.md",
    ".claude/commands/mao-export-pack.md",
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
    "skills/meta-agent-os/references"
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

    if ($knownStages -notcontains $stageState.current_stage) {
        Add-Error "STAGE_STATE current_stage is not in STAGE_MANIFEST: $($stageState.current_stage)"
    }

    foreach ($completedStage in $stageState.completed_stages) {
        if ($knownStages -notcontains $completedStage) {
            Add-Error "STAGE_STATE completed_stages contains unknown stage: $completedStage"
            continue
        }

        $manifestEntry = $stageManifest.stages | Where-Object { $_.name -eq $completedStage } | Select-Object -First 1
        Test-RequiredPath $manifestEntry.output "completed stage output" | Out-Null

        if ($null -ne $stageState.stage_status -and $stageState.stage_status.$completedStage -ne "complete") {
            Add-Error "STAGE_STATE completed stage '$completedStage' is not marked complete in stage_status."
        }
    }

    if ($null -ne $stageState.stage_status -and $stageState.status -eq "in_progress") {
        $currentStatus = $stageState.stage_status.($stageState.current_stage)
        if ($currentStatus -ne "in_progress") {
            Add-Error "STAGE_STATE current stage '$($stageState.current_stage)' has status '$currentStatus' but top-level status is in_progress."
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
        "ROADMAP.md"
    )

    foreach ($file in $scanFiles) {
        $resolved = Resolve-RepoPath $file
        if (-not (Test-Path -LiteralPath $resolved)) { continue }
        $content = Get-Content -Raw -LiteralPath $resolved
        if ($content -match "TODO:|{{[^}]+}}") {
            Add-Error "Strict mode: unresolved placeholder in $file"
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Meta Agent OS hardening check failed:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host " - $error" -ForegroundColor Red
    }
    exit 1
}

if ($Strict) {
    Write-Host "Meta Agent OS hardening check passed in strict mode." -ForegroundColor Green
}
else {
    Write-Host "Meta Agent OS hardening check passed." -ForegroundColor Green
}

exit 0
