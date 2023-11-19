
<!-- ABOUT THE PROJECT -->
## About GetTranscriptYT

Get the full transcript of a YouTube video and save it to a file or to clipboard.

Using the transcript as input (prompt) in ChatGPT allows for various outcomes, such as summaries, translations, and more.

### Built With
Dependences:

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

Hold down the 'Win' key and press 'R'. Then, in the following dialog box, type `SystemPropertiesAdvanced`.

Add the full path of the executables to the PATH environment.

### Usage

```sh
[string] $url = "https://www.youtube.com/watch?v=<ID-VIDEO>"
$transcript = [YtTranscription]::new($url)
```

Saving the transcript in a file (result.txt)

```sh
$transcript.saveTranscriptionInTxtFile()
```

Send to windows clipboard

```sh
$transcript.sendTranscriptionToClipboard()
```

Send to clipboard with prompt to chatGPT

```sh
$transcript.sendToClipboardWithGPTPromptBefore()
```
<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[PShell-img]: https://img.shields.io/badge/PowerShell-5391FE?style=plastic&logo=powershell&logoColor=5391FEf&labelColor=ffffff
[PShell-url]: https://learn.microsoft.com/en-us/training/modules/introduction-to-powershell/
[FFmpeg-img]: https://img.shields.io/badge/FFmpeg-007808?style=plastic&logo=ffmpeg&logoColor=007808&labelColor=ffffff
[FFmpeg-url]: https://www.ffmpeg.org/
[YTDLP-img]: https://img.shields.io/badge/YTDLP-ff0000?style=plastic&logo=ytdlp&logoColor=ff0000&labelColor=ffffff
[YTDLP-url]: https://github.com/yt-dlp/yt-dlp
