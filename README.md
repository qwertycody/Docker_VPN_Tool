# Docker VPN Tool
A tool utilizing Docker that allows you to be able to connected to multiple Cisco AnyConnect/OpenConnect networks at one time

Like many of you, I use Cisco AnyConnect to connect to Networks.

In my case, I had two separate Cisco AnyConnect networks that I needed to be connected to in order to be connected to a Virtual Desktop/Server through either RDP/SSH on each network.

As a result, I started digging into the IP Stack and seeing about ways to leverage Docker to segment route mapping and allow something like this to work to my advantage.

Here’s a rough sketch of what’s done here:

# Step 1:

My Local Computer -> Spin Up Docker Container -> Have Docker Container Connect to Remote Cisco AnyConnect Endpoint

# Step 2:

My Local Computer -> Allocate a local port and forward it to a remote address INSIDE the Docker Container (Destination IP/DNS and Port)

# Step 3:

My Local Computer -> Open RDP/SSH Session on localhost and allocated local port -> Connection to Remote Desktop/Server Succeeded!

Now, I had a few issues getting this up and going and the major one was making sure that the OpenConnect/AnyConnect Client wasn’t effectively blocking out ssh connections to allow this port forward allocation. However, I DID end up finding a way around this and made sure that the OpenConnect/AnyConnect Client wasn’t hijacking all requests to port 22 and instead was only hijacking/redirecting requests to the VPN. I accomplished this by using a nifty tool called VPN Splice.

You can check out this awesome utility written by Dan Lenski here:

https://github.com/dlenski/vpn-slice

All in all I ended up with this great combo of work and I am extremely proud of it. It has to be the most complex little tool I think I have ever written and it would NOT be possible without the people over at Docker.
