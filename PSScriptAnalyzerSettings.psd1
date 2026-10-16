# PSScriptAnalyzer settings for Meta Agent OS.
# Run locally:  Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
@{
    # Information-level findings (for example positional parameters in internal
    # helper calls) are advisory; CI fails on Error and Warning only.
    Severity     = @('Error', 'Warning')

    ExcludeRules = @(
        # check-meta-agent-os.ps1 prints a coloured pass/fail summary for a human
        # at the terminal (and plain JSON on stdout with -Json). Write-Host is the
        # intended channel for the human summary, not a pipeline mistake.
        'PSAvoidUsingWriteHost',

        # Get-RequiredSections, Get-SectionBodies and Test-StageOutputSections
        # operate on a set of sections by design. Renaming them would churn the
        # checker for no behavioural gain; the names describe what they do.
        'PSUseSingularNouns'
    )
}
