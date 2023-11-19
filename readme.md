
### Get the full transcript of a YouTube video and save it to a file or to clipboard.

Dependences:

[YT-DLP](https://github.com/yt-dlp/yt-dlp)

[FFmpeg](https://ffmpeg.org/download.html)

## About The Project

### Built With
This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [![PShell][PShell-img]][PShell-url]
* [![FFmpeg][FFmpeg-img]][FFmpeg-url]
* [![YT-DLP][YT-DLP-img]][YT-DLP-url]

### Usage

```sh
[string] $url = "https://www.youtube.com/watch?v=<ID-VIDEO>"`
$transcript = [YtTranscription]::new($url)"
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

[PShell-img]: https://img.shields.io/badge/PowerShell-4376cf?style=plastic&logo=powershell&logoColor=4376cf&labelColor=ffffff
[PShell-url]: https://learn.microsoft.com/en-us/training/modules/introduction-to-powershell/
[YT-DLP-url]: https://github.com/yt-dlp/yt-dlp
