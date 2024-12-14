# Analyze PCAPs Docker

#### A bit of mumbo jumbo for the background:

This is one of the components to a project that I just haven't been able to work on, but the general idea was to try to create a module like framework/platform to analyze, parse, extract, etc a bunch of data
collected from various different sources such as pcaps (network sniffing via something like tcpdump), wifi (bettercap project I have on my Raspberry Pi Zero W), wardriving (I want to eventually get the hardware
to run something like Kismet with GPS and other features, website scanning (I started this, but got busy with other projects that were more important), OSINT, etc.

The way I figured how to do this is using docker containers since they are portable and I started to get the general idea. I have diagrams and flow charts in notebooks, but just haven't uploaded everything.

The final output is JSON so I can port this into ELK to display in nice fancy graphs and easier to search/digest.

----

The main script is the [parse_pcap.sh](https://github.com/dleto614/docker-analyze-pcaps/blob/main/drop_files/scripts/parse_pcap.sh) and this is where all the tools installed via the docker are run to extract as
much info as possible. It is also supposed to run in the background and the data extracted is saved to mounted filesystems which could also be used to monitor to upload to another server (vps perferablly) which
than is monitored by something like rclone which does have support for SSH, but I never got around to building this component.

------

To monitor for new pcap files to try to process I created a lovely script called [monitor_pcap.sh](https://github.com/dleto614/docker-analyze-pcaps/blob/main/drop_files/scripts/monitor_pcap.sh) which used the

`inotifywait` linux program and it waits for files in the `/opt/drop_files/pcaps/`, but only looks for files that were "created" or "moved".

------

This took a bit of effort, but I wanted something that used linux tools and components as much as possible. I haven't been able to properly test this in real world scenarios, but I do plan on working on this in
the future.
