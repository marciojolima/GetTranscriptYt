
Class YtTranscription{
    [string] $ytUrl
    [object] $out
    [string] $fileName
    [string] $fileNameExtension
    
    YtTranscription($ytUrl){
        $this.ytUrl = $ytUrl
        $this.fileNameExtension = "srt"
        $this._generateRawTranscription()
    }

    [void] getSanitizeTranscription(){
        Write-Host "In progress..."
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
$transcript.getSanitizeTranscription()