
Class YtTranscription{
    [string] $ytUrl
    [object] $out
    [string] $fileName
    [string] $fileNameExtension
    [string[]] $outputTranscription
    
    YtTranscription($ytUrl){
        $this.ytUrl = $ytUrl
        $this.fileNameExtension = "srt"
        $this._generateRawTranscription()
        $this._sanitizeTranscription()
    }

    [void] saveTranscriptionInTxtFile(){
        $this.outputTranscription | Out-File "result.txt"
        Write-Host "Saved in result.txt"
    }

    [void] sendTranscriptionToClipboard(){
        $this.outputTranscription | Set-Clipboard
        Write-Host "Copied to Clippboard"
    }

    [void] sendToClipboardWithGPTPromptBefore(){
        [string[]] $prompt = @()
        $prompt = Get-Content -Path ".\prompt-ChatGPT.txt"
        #join arrays and send to clipboard
        $prompt + $this.outputTranscription | Set-Clipboard 
        Write-Host "ChatGPT prepared"
    }

    [void] _sanitizeTranscription(){
        [string] $filePath = -join(".\", $this.fileName)
        [string[]] $content = @()
        $content = Get-Content -Path  $filePath

        [string] $timePattern = "[0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3} --> [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}"
        [string] $numberPattern = "[0-9]{1,6}" #line numbers
        [string] $emptyPattern = "^$"
        [string] $noiseDescriptionPattern = "^\(.*\)$" #Any char, since start "(" and end ")"
        [string] $fullPattern = "($timePattern)|($numberPattern)|($emptyPattern)|($noiseDescriptionPattern)"
        
        $this.outputTranscription = foreach($line in $content){
            $isMatch = $line -match $fullPattern
            if($isMatch) {continue}
            Write-Output $line
        }

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
            $textOut -match 'ID_[a-zA-Z0-9!@#$&()\\-`.+,/\"]*_result.[a-zA-Z]{2}.'
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
$transcript = [YtTranscription]::new($url)
#$transcript.saveTranscriptionInTxtFile()
#$transcript.sendTranscriptionToClipboard()
$transcript.sendToClipboardWithGPTPromptBefore()