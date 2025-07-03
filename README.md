> [!WARNING]
> ARM devices are not supported by this container. It is only for x86_64 devices. (See: https://github.com/mudler/LocalAI/issues/5778)


# Local AI with Vulkan support Community Container for Nextcloud All-In-One

This container is used in [Nextcloud All-In-One](https://github.com/nextcloud/all-in-one/tree/main/community-containers/local-ai-vulkan) AI backend for Nextcloud Assistant.

## Features

Compared to a default LocalAI container, this container allows:
- Automatic configuration of Nextcloud Assistant.
- Support Hardware acceleration with Vulkan.
- *(Planned)* Esseay access to local AI web interface.

## Getting Started

### Prerequisites

In general, you need:
- A Nextcloud instance running on a server with x86_64 architecture.
- Have enough storage space available (at least 7GB).

For hardware acceleration, you need:
- A GPU that supports Vulkan. Run `vulkaninfo` in the terminal to check if it is enabled.
- The [DRI device enabled](https://github.com/nextcloud/all-in-one/tree/main#with-open-source-drivers-mesa-for-amd-intel-and-new-drivers-nouveau-for-nvidia) in the AIO. You can do this by adding `--env NEXTCLOUD_ENABLE_DRI_DEVICE=true` to the container.

### Installation

See [how to use community containers](https://github.com/nextcloud/all-in-one/tree/main/community-containers#how-to-use-this).

After installation on Nextcloud, go to `https://$NC_DOMAIN/settings/admin/ai` and enable the Local AI server.
You must also configure the models you want to use there.

### How access Local AI web interface

> [!NOTE]
> Local AI web interface does not have any authentication, so you should protect it.

To access the Local AI web interface, you must use a reverse proxy. You can use Caddy, Nginx, or any other reverse proxy server.

For example, if you use Caddy, you can add the following configuration to your Caddyfile:

```Caddyfile
http://local-ai.your-nc-domain.com {
    # Local AI web interface haven't any authentication, so you should protect it
    basic_auth {
        # Username "Bob", password "hiccup"
        Bob $2a$14$Zkx19XLiW6VYouLHR5NmfOFU0z2GTNmpkT/5qqR7hx4IjWJPDhjvG
    }
    reverse_proxy nenxtcloud-aio-local-ai-vulkan:8080
}
```