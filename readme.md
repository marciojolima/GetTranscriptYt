
<!-- ABOUT THE PROJECT -->
## About GetTranscriptYT

Get the full `AUTOMATIC` transcript of a YouTube video and save it to a file or to clipboard.

Using the transcript as input (prompt) in ChatGPT allows for various outcomes, such as summaries, translations, and more.

### Built With

* [![PShell][PShell-img]][PShell-url]
* [![FFmpeg][FFmpeg-img]][FFmpeg-url]
* [![YTDLP][YTDLP-img]][YTDLP-url]


<!-- GETTING STARTED -->
## Getting Started

Before running this PowerShell script, you need to install the [FFmpeg](https://ffmpeg.org/download.html) and the [YT-DLP](https://github.com/yt-dlp/yt-dlp#release-files) binaries and set up its corresponding binary in the Windows environment variables PATH.

### Prerequisites

This files need to be set in PATH environment:
* [yt-dlp.exe](https://github.com/yt-dlp/yt-dlp#release-files)
* [ffmpeg.exe](https://ffmpeg.org/download.html)

### Installation

Hold down the 'Win' key and press 'R'(`Win+R`). Then, in the following dialog box, type `SystemPropertiesAdvanced`.

Add the full path of the executables to the PATH environment.

### Usage

Open the PowerShell terminal and navigate to the directory where the GetTranscriptYt.ps1 file is located.

Common usage:
```sh
GetTranscriptYt.ps1 -ytlink https://www.youtube.com/watch?v=<video-id>
```

`-out` options

The parameter -out accepts: clip (default), gpt, or file.
* clip: copies the transcription to the system clipboard.
* gpt: copies the transcription to the system clipboard and prepends a prompt to paste on ChatGPT.
* file: creates a result.txt file int the current directory with the automatic transcription

Sending the transcription to the system clipboard (default behavior):
```sh
GetTranscriptYt.ps1 -ytlink https://www.youtube.com/watch?v=<video-id> -out file
```

Saving automatic transcription in the result.txt:
```sh
GetTranscriptYt.ps1 -ytlink https://www.youtube.com/watch?v=<video-id> -out file
```

Sending the transcription to the clipboard with prepended prompt to organize the text:
```sh
GetTranscriptYt.ps1 -ytlink https://www.youtube.com/watch?v=<video-id> -out gpt
```

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[PShell-img]: https://img.shields.io/badge/PowerShell-5391FE?style=plastic&logo=powershell&logoColor=5391FEf&labelColor=ffffff
[PShell-url]: https://learn.microsoft.com/en-us/training/modules/introduction-to-powershell/
[FFmpeg-img]: https://img.shields.io/badge/FFmpeg-007808?style=plastic&logo=ffmpeg&logoColor=007808&labelColor=ffffff
[FFmpeg-url]: https://www.ffmpeg.org/
[YTDLP-img]: https://img.shields.io/badge/YTDLP-ff0000?style=plastic&logo=ytdlp&logoColor=ff0000&labelColor=ffffff
[YTDLP-url]: https://github.com/yt-dlp/yt-dlp
