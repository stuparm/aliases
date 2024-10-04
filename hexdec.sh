# Conversion between hexadecimal and decimal numbers
# usage
#   - h2d 0x123
#   - d2h 123

funcHex2Dec() {
    hex=$1:u
    if [[ $hex == 0X* ]]; then
        hex="${hex:2}"
    fi
    echo "obase=10; ibase=16; $hex" | bc

}
alias h2d=funcHex2Dec

funcDec2Hex() {
    dec=$1:u
    echo -n "0x"
    echo "obase=16; ibase=10; $dec" | bc
}
alias d2h=funcDec2Hex
