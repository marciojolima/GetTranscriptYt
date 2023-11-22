

Class TranscriptionSanitization{
    [string[]] $outputTranscription
    [string] $fileName
    [bool] $isNextLineRepeat = $false
    [string] $lastLineValue = ""

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
    [string[]] getOutput(){
        return $this.outputTranscription
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
