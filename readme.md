# New Windows Machine Setup

> HAVEN'T TESTED THIS YET!

With a configuration like this:

```json
// .\config.json
{
    "programs": {
        "<group1>": ["<id>", "<id>"],
        "<group2>": [{"<name>": "id"}],
    },
    "disToCreate": ["<path>", "<path>"],
    "defaultPaths": [{"<key>": "<path>"}]
}
```

This script will:

- Install the specified programs with winget.
- Create the specified directories
- Change the default path for some specific windows folders.

This script DOESN'T but could do in the future:

- Remove bloatware, like Skype.

## Other resources / notes

- [Install winget](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1)
- Install WSL with: `wsl --install`
- Run everything as an administrator to avoid elevation promts.
- This repository also has a backup for some of my configuration files.
