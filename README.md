# ffbuilder
A command line builder for FFMPEG

Simple single web page to help build FFMPEG command lines repeatedly and consistently.
Currently focused around live HLS and DASH stream creation - with particular focus on DASH-LL stream creation.
It also supports RTMP and MPEG-TS over UDP as input and output methods.

The tool provides a simple interactive way to see how to build up an FFMPEG command.
As you select options on the left, the required command line syntax is added to script on the right.

The output of the tool is script you can run from a Linux/Mac shell, others have adapted the output to Windows batch script.

Page can be run from anywhere, should work in most browsers. Predominately tested in Chrome. 

A hosted version can be found here: https://moctodemo.akamaized.net/tools/ffbuilder/

This tool has been used to build and maintain industry reference streams for DASH.js and was recently used by a European public broadcaster to build backup services for their TV and radio channels.

![image](https://user-images.githubusercontent.com/16843500/135630604-71ddba11-8dbb-41cd-b4ff-e9fedc252a25.png)

## Things on the todo list

- Add option to format script in windows batch script
- Build better RTMP input options
- Add HEVC/AV1/etc support
- Enable more ingest server formats
