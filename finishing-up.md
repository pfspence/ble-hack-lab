## Finishing up

Thats it for this lab. You are welcome to continue to try the other challenges.
If you are done, reset the CTF by writing `0xC1EA12` to handle `0x0032`.

```bash
$ gatttool -b 94:B9:7E:FA:27:72 --char-write-req -a 0x0032 -n C1EA12
```

### References
- <a href="https://github.com/hackgnar/ble_ctf_infinity">https://github.com/hackgnar/ble_ctf_infinity</a>
- Chapter 11 of <a href="https://nostarch.com/practical-iot-hacking">Practical IoT Hacking</a> from No Starch Press.
