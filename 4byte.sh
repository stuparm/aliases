# Decode hexadecimal data from input or event to human readable format
# Under the hood it uses the Tenderly RPC API
# Usage
#  - 4byte 0xa9059cbb2ab09eb219583f4a59a5d0623ade346d962bcd4e46b11da047c9049b
#  - 4byte 0x15c49a16

func4byte() {
    input=$1

    if [[ $input != 0x* ]]; then
        echo "Input is not 0x prefixed"
        return
    fi

    ok=1
    if [[ ${#input} -eq 10 ]]; then
        echo "Checking function signature..."
        response=$(funcFunctionSignature "$input")
        signature=$(funcParseSignature "$response")
        echo $signature

        ok=0
    fi

    if [[ ${#input} -eq 10 && $ok -eq 1 ]]; then
        echo "Checking error signature..."
        response=$(funcErrorSignature "$input")
        signature=$(funcParseSignature "$response")
        echo $signature

        ok=0
    fi 

    if [[ ${#input} -eq 66 && $ok -eq 1 ]]; then
        echo "Checking event signature..."
        response=$(funcEventSignature "$input")
        signature=$(funcParseSignature "$response")
        echo $signature

        ok=0
    fi

    if [[ $ok -eq 1 ]]; then
        echo "Invalid input"
    fi
}
alias 4byte=func4byte

funcFunctionSignature() {
    input=$1

    response=$(curl --location $RPC_MAINNET -s \
        --header 'Content-Type: application/json' \
        --data '{"method": "tenderly_functionSignatures","params": ["'$input'"] }')

    echo $response
}

funcEventSignature() {
    input=$1

    response=$(curl --location $RPC_MAINNET -s \
        --header 'Content-Type: application/json' \
        --data '{"method": "tenderly_eventSignature","params": ["'$input'"] }')

    echo $response
}

funcErrorSignature() {
    input=$1

    response=$(curl --location $RPC_MAINNET -s \
        --header 'Content-Type: application/json' \
        --data '{"method": "tenderly_errorSignatures","params": ["'$input'"] }')

    echo $response
}

funcParseSignature() {
    json=$1

    function="> "
    obj=$(echo $json | jq '.result | if type == "array" then .[0] else . end')

    #check if obj is empty
    if jq -e '. | length == 0' <<<$obj >/dev/null 2>&1; then
        echo $function
        return
    fi

    fnName=$(echo $obj | jq -r '.name')
    fnParams=$(echo $obj | jq -r '.inputs | map(.type) | join(", ")')
    function=$function$fnName\($fnParams\)\\n

    echo $function
}

