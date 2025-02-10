
. $PWD\functions.ps1

$ProgressPreference = 'SilentlyContinue'

$Global:ENV_FILE = "$PSScriptRoot\.env"      
$Global:USER_ENV = Get-Env

Write-Host "`nThis will setup your env with (Git, Composer, NVM, Chocolatey, Some terminal utilities, Cmder)`n"

#region ANSWER QUESTIONS FOR WHICH STEPS TO EXECUTE
$StepsQuestions = [ordered]@{
   COMPOSER = [PSCustomObject]@{ Question = "- Download Composer ?"; Answer = "no" }
   GIT = [PSCustomObject]@{ Question = "- Download Git ?"; Answer = "no" }
   NVM = [PSCustomObject]@{ Question = "- Download NVM (Node Version Manager) ?"; Answer = "no" }
   PVM = [PSCustomObject]@{ Question = "- Download PVM (PHP Version Manager) ?"; Answer = "no" }
   REDIS = [PSCustomObject]@{ Question = "- Download Redis ?"; Answer = "no" }
   TOOLS = [PSCustomObject]@{ Question = "- Download TOOLS (eza, delta, bat, fzf, zoxide, tldr) ?"; Answer = "no" }
   CMDER = [PSCustomObject]@{ Question = "- Download & Configure Cmder ?"; Answer = "no" }
   FONTS = [PSCustomObject]@{ Question = "- Download Nerd Fonts "; Answer = "no" }
}

foreach ($key in $StepsQuestions.Keys) {
    $q = $StepsQuestions[$key]
    $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "yes"
}
#endregion

$WhatWasDoneMessages = @()
$WhatToDoNext = @()

#region SETUP THE CONTAINER DIRECTORY
$downloadPath = Setup-Container-Directory
Write-Host "`n- Your working directory is $downloadPath :) " -BackgroundColor Green -ForegroundColor Black
$WhatToDoNext = Set-Todo-Message -message "Your container path is '$downloadPath'" -WhatToDoNext $WhatToDoNext

$overrideExistingEnvVars = Prompt-YesOrNoWithDefault -message "`nWould you like to override the existing environment variables"


. $PWD\steps\install-composer.ps1

. $PWD\steps\install-git-nvm.ps1

. $PWD\steps\install-tools.ps1

. $PWD\steps\install-cmder.ps1

. $PWD\steps\install-fonts.ps1


$WhatToDoNext = Set-Todo-Message -message "Run ./followup.ps1 when you're done for additional cmder configuration" -WhatToDoNext $WhatToDoNext

#region WHAT TO DO NEXT
What-ToDo-Next -WhatWasDoneMessages $WhatWasDoneMessages -WhatToDoNext $WhatToDoNext
#endregion
