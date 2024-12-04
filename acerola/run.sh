haxe example.hxml                   && \
haxe test-unit-js.hxml              && \
haxe test-unit-acerola.hxml         && \
haxe test-api-acerola.hxml

if [ $? -ne 0 ]; then
    echo ""
    echo "BUILD ERROR"
    echo ""
    exit 1  # Encerra o script com código de saída 1
fi

bash -c "node ./build/acerola/api/api.js" &
NODE_PID=$!
echo "Servidor iniciado em: $NODE_PID"

sleep 2s;

# run server tests
# node ./build/acerola/test/unit-js.js        && \
node ./build/acerola/test/unit.js           && \
java -jar ./build/acerola/test/api/AcerolaApiTest.jar

echo "Kill node server at PID: $NODE_PID"
kill $NODE_PID &

