<#
******* Class TranscriptionSanitization *******
#>

Class TranscriptionSanitization{
    [string[]] $outputTranscription
    [string] $fileName
    [bool] $isNextLineRepeat = $false
    [string] $lastLineValue = ""
    [ref] $refOutputTranscription #[PSreference]

    TranscriptionSanitization($pathFileName){
        if($pathFileName -eq ""){
            Write-Warning "Empty file."
        }
        if(Test-Path $pathFileName){
            $this.fileName = $pathFileName
            $this._setOutputTranscription()
        } else {
            Write-Warning "The $pathFileName is invalid."
        }
    }

    #return a reference to array of strings
    [ref] getOutput(){
        return $this.refOutputTranscription
    }

    [void] _setOutputTranscription(){
        [string[]] $content = @()
        [bool] $isInValidLine = $false

        $content = Get-Content -Path  $this.fileName
        $this.outputTranscription = foreach($line in $content){

            $isInValidLine = $this._invalidPattern($line)
            if($isInValidLine){continue}

            $this._checkRepeateLine($line)
            if(!$this.isNextLineRepeat){
                Write-Output $line
            }
        }
        $this.refOutputTranscription = $this.outputTranscription
    }

    [void] _checkBugTimeWrite($line){
        #pattern sample 00:00:02,000 --> 00:00:04,550
        [string] $timePattern = "[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"
        
        if($line -match $timePattern){

            $m = Select-String "[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}" -AllMatches -InputObject $line
            [TimeSpan]$t1 = [TimeSpan]::Parse($m.Matches[0].Value)
            [TimeSpan]$t2 = [TimeSpan]::Parse($m.Matches[1].Value)
            [TimeSpan]$diffTime = $t2 - $t1

            #if the time was write between 20ms or less
            if($diffTime.TotalMilliseconds -le 20){
                Write-Host "The next line valid value will be the same"
                
            } else {
                
            }
        }
    }

    [void] _checkRepeateLine($line){
        
        if($this.lastLineValue -ne $line){
            $this.isNextLineRepeat = $false
            $this.lastLineValue = $line
        } else {
            $this.isNextLineRepeat = $true
        }

    }

    [bool] _invalidPattern($line){
        [string] $timePattern = "[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"
        [string] $numberPattern = "[0-9]{1,6}" #line numbers
        [string] $emptyPattern = "^$"
        [string] $oneSpacePattern = "^ $"
        [string] $noiseDescriptionPattern = "^\(.*\)$" #Any char, since start "(" and end ")"
        [string] $fullPattern = "($timePattern)|($numberPattern)|($emptyPattern)|($oneSpacePattern)|($noiseDescriptionPattern)"

        return $line -match $fullPattern
    }
}

<#
******* Class YtTranscription *******
#>
Class YtTranscription{
    [string] $ytUrl
    [object] $out
    [string] $fileName
    [string] $fileNameExtension
    [ref] $outputTranscription
    
    YtTranscription($ytUrl){
        $this.ytUrl = $ytUrl
        $this.fileNameExtension = "srt"
        [ref] $this.outputTranscription = @()
        $this._generateRawTranscription()
        $this._sanitizeTranscription()
    }

    [void] saveTranscriptionInTxtFile(){
        $this.outputTranscription.Value | Out-File "result.txt"
        Write-Host "Saved in result.txt"
    }

    [void] sendTranscriptionToClipboard(){
        $this.outputTranscription.Value | Set-Clipboard
        Write-Host "Copied to Clippboard"
    }

    [void] sendToClipboardWithGPTPromptBefore(){
        [string[]] $prompt = @()
        $prompt = Get-Content -Path ".\prompt-ChatGPT.txt"
        #join arrays and send to clipboard
        $prompt + $this.outputTranscription.Value | Set-Clipboard 
        Write-Host "ChatGPT prepared"
    }

    [void] _sanitizeTranscription(){
        [string] $filePath = -join(".\", $this.fileName)
        $sanitizer = [TranscriptionSanitization]::new($filePath)
        $this.outputTranscription = $sanitizer.getOutput()
    }

    [void] _generateRawTranscription(){
        [bool] $success = $false
        Write-Host $this.ytUrl
        $this._executeYTDLP()
        $success = $this._checkOut()
        if($success) {
            $this._setFileName()
            Write-Host "Transcript filename:" + $this.fileName
        }
    }

    [void] _setFileName(){
        [int] $lastIndex = $this.out.Count - 1
        [string] $textOut = $this.out[$lastIndex]
        $matchObj = Select-String -Pattern "original file ID_" -AllMatches -InputObject $textOut
        
        #Found
        if($matchObj.Matches.Count -gt 0){
            [string] $pattern = 'ID_[a-zA-Z0-9_\-!@#$&.+]*_result.[a-zA-Z]{2}.'
            try {
                $textOut -match $pattern
            }
            catch{
                Write-Host $_
            }
            $this.fileName = $Matches[0] + $this.fileNameExtension
        } else {
            Write-Warning "It wasn't possible to retrieve the file name."
        }
    }

    [void] _executeYTDLP(){
        try {
            $this.out = yt-dlp `
                -o 'ID_%(id)s_%(creator)s_result' `
                --write-auto-subs `
                --convert-subs $this.fileNameExtension `
                --skip-download `
                $this.ytUrl 
        }
        catch {
            Write-Host "An error occurred:"
            Write-Host $_
        }
    }

    [bool] _checkOut(){
        if ($this.out.Count -gt 1){return $true}

        Write-Warning "Somenthing get wrong."
        if($this.out -is [System.Array]){
            foreach($item in $this.out){
                Write-Warning $item
            }
        }

        if($this.out -is [string]){
            Write-Warning $this.out
        }

        return $false
    }
    
}

[string] $url = "https://www.youtube.com/watch?v=yiHgmNBOzkc"
$url = "https://www.youtube.com/watch?v=dSGW-DLMnUc"
$transcript = [YtTranscription]::new($url)
#$transcript.saveTranscriptionInTxtFile()
#$transcript.sendTranscriptionToClipboard()
$transcript.sendToClipboardWithGPTPromptBefore()