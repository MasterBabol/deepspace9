# Deepspace 9

A factorio mod: transfer items, technologies, and signals between servers via rockets.



## Introduction

TODO: fill



## Building & Installation

```sh
make
```

This will create a zip file. Copy the zip file to the mod directory in the read-directory of a factorio game instance.



## API

### File (unix FIFO) Interface 

| File (unix FIFO) Name | Direction | Description                                                  |
| --------------------- | --------- | ------------------------------------------------------------ |
| rx-queue.fifo         | MOD to LA | Request a rx reservation, series of {request-json}           |
| tx-queue.fifo         | MOD to LA | Send a tx request, series of {signal-json}                   |
| tx-sigqueue.fifo      | MOD to LA | Send signals, series of {techsync-json}                      |
| techsync.fifo         | MOD to LA | Send research states of technologies, series of {techsync-json} |

DS9 mod will create each file as soon as it needs to send or announce a rx/tx request or states of signals and technologies. These files are located in a directory named "script-output" in the read-directory of factorio game instance.



### Rcon Interface

| Rcon Command                           | Direction | Description                      |
| ------------------------------------ | --------- | --------- |
| /confirm_rx_reservation {request-json} | LA to MOD | Confirm a rx reservation request |
| /set_rx_signals {signal-json} | LA to MOD | Set external signals |
| /set_technologies {techsync-json} | LA to MOD | Set external technologies |
| /add_technologies {techsync-json} | LA to MOD | Merge external technologies |

These commands are always valid and active and can be issued by any user via a Rcon interface Factorio provides. A user can expose a Rcon interface by running a headless factorio server with arguments: --rcon-password 'password' --rcon-port 'port'.



### JSON Structure

#### request-json

| Child Name | Description |
| -------------- | ----------- |
| id   | Unique id (factorio LuaEntity; entity.unit_number) for this request |
| type | Request type<br />1: reservation: reservation of a rx request<br />2: revokation: revokation of a rx reservation<br />3: return: return remained items of a rx reservation |
| items  | Dictionary string (item name) -> uint (item count) |
| ttl | Time to live (only valid in case of reservation) |

#### signal-json

| Child Name                | Description                  |
| ------------------------- | ---------------------------- |
| [{signal-item-json}, ...] | Array of {signal-item-json}s |

#### signal-item-json

| Child Name | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| index      | Signal index<br />must be consecutive numbers start from 1 (lua-array dependent) |
| signal     | Factorio SignalID<br />type: string: "item", "fluid", or "virtual"<br />name: string: name of the item, fluid or virtual sign |
| count      | Count value of the signal                                    |

#### techsync-json

| Child Name                  | Description                    |
| --------------------------- | ------------------------------ |
| [{techsync-item-json}, ...] | Array of {techsync-item-json}s |

#### techsync-item-json

| Child Name | Description                                             |
| ---------- | ------------------------------------------------------- |
| name       | Technology name                                         |
| researched | Has this technology been researched                     |
| progress   | Progress of the technology, as a number in range [0, 1] |
| level      | Level of the technology                                 |

