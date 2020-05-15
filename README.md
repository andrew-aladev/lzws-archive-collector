# LZW .Z archive collector scripts

There are great amount of `.Z` archives available on the internet.
It is possible to test lzws using these archives.

Please download [lzws library](https://github.com/andrew-aladev/lzws) first and set its path.
```sh
export LZWS_PATH="~/workspace/lzws"
```

By default `LZWS_PATH` will be equal to `..` (used as `lzws` git submodule).

Install modern version of ruby:
```sh
curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby-2.7.1 -C --enable-socks
```

Install required gems:
```sh
bundle install
```

Than you need to start tor.
Please use some convenient timeout like `SocksTimeout 10`.

Than you need to start privoxy, use config:
```
listen-address 127.0.0.1:8118
toggle 0
forward-socks5t / 127.0.0.1:9050 .
```

Update urls:
```sh
./scripts/update_urls.sh
```

Re-test archives:
```sh
./scripts/clear_results.sh
./scripts/test_archives.sh
```

This test will decompress and re-compress more than 10000 unique archives in all possible combinations of dictionaries and lzws options.
It will take a week on modern CPU (there are many large archives).
CPU with 16+ cores is recommended.
Test will be successful if file [volatile_archives.xz](data/volatile_archives.xz) will be empty.
Volatile archives means the list of archives that lzws/ncompress can process, but ncompress/lzws can't.

Please read [documentation](doc/real_world_testing.txt).

## License

MIT license, see LICENSE and AUTHORS.
