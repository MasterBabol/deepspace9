# Deepspace 9

A factorio mod: transfer items, technologies, and signals between servers via rockets.



## Introduction

TODO: fill



## Building & Installation

```sh
pacman -S lua
make clean && make
```

This will create a zip file. Copy the zip file to the mod directory in the read-directory of a factorio game instance.



## API

### ~~File (unix FIFO) Interface~~ 

| ~~File (unix FIFO) Name~~ | ~~Direction~~ | ~~Description~~                                              |
| ------------------------- | ------------- | ------------------------------------------------------------ |
| ~~rx-queue.fifo~~         | ~~MOD to LE~~ | ~~Request a rx reservation, series of {request-json}~~       |
| ~~tx-queue.fifo~~         | ~~MOD to LE~~ | ~~Send a tx request, series of {request-json}~~              |
| ~~tx-sigqueue.fifo~~      | ~~MOD to LE~~ | ~~Send signals, series of {signal-json}~~                    |
| ~~techsync.fifo~~         | ~~MOD to LE~~ | ~~Send research states of technologies, series of {techsync-json}~~ |

~~DS9 mod will create each file as soon as it needs to send or announce a rx/tx request or states of signals and technologies. These files are located in a directory named "script-output" in the read-directory of factorio game instance.~~

File interfaces are deprecated and not used. All MOD to LA pipe functions are moved to Rcon interface.



### Rcon Interface

| Rcon Command                           | Direction | Description                      |
| ------------------------------------ | --------- | --------- |
| /dequeue_rx_queue | MOD to LE | Dequeue rx reservation requests,<br />(array of){request-json} |
| /dequeue_tx_queue | MOD to LE | Dequeue tx requests,<br />(array of){request-json} |
| /collect_rx_signal_reqs | MOD to LE | Collect rx signal requests,<br />(array of){signal-json} |
| /collect_tx_signals | MOD to LE | Collect tx signal requests,<br />(array of){signal-json} |
| /collect_rx_elec_reqs | MOD to LE | Collect rx power requests,<br />(array of){elec-json} |
| /collect_tx_elecs | MOD to LE | Collect tx power requests,<br />(array of){elec-json} |
| /collect_technology_researches | MOD to LE | Collect research states and levels,<br />(array of){techsync-json} |
| /confirm_rx_reservation <br />(array of){request-json} | LE to MOD | Confirm a rx reservation request |
| /set_rx_signals <br />(array of){signal-json} | LE to MOD | Set signals on signal receivers |
| /set_rx_elecs <br />(array of){elec-json} | LE to MOD | Set energies on power receivers |
| /set_technologies <br />(array of){techsync-json} | LE to MOD | Apply higher-level technologies to local game |
| ~~/add_technologies <br />(array of){techsync-json}~~ | ~~LE to MOD~~ | ~~Merge external technologies~~<br />deprecated |

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

| Child Name | Description                               |
| ---------- | ----------------------------------------- |
| id         | ID of the entity                          |
| name       | Name of the signal                        |
| type       | Type of the signal                        |
| count      | Count of the signal (used in tx requests) |

#### elec-json

| Child Name | Description                  |
| ---------- | ---------------------------- |
| id         | ID of the entity             |
| amount     | Amount of electricity energy |

#### techsync-json

| Child Name   | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| name         | Technology name                                              |
| researched   | Has this technology been researched                          |
| ~~progress~~ | ~~Progress of the technology, as a number in range [0, 1]~~ currently not used |
| level        | Level of the technology                                      |

