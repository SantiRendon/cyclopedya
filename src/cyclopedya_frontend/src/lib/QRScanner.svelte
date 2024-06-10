<script>
  import { onMount } from "svelte";
  import { Html5QrcodeScanner } from "html5-qrcode";

  let scanner;
  let scannerValue;

  let setScannerValue = (value) => {
    scannerValue = decodedResult.result.text;
    scanner.pause();
    console.log(scannerValue);
  };

  const onScanSuccess = (decodedText, decodedResult) => {
    // console.log(`Code matched = ${decodedText}`, decodedResult);
    console.log(decodedResult.result.text);
    scannerValue = decodedResult.result.text;
    // scanner.pause();
    // console.log(scannerValue);
    // return `Code matched = ${decodedText?.decodedResult?.text} : decodedResult`
    // Aquí puedes manejar el texto decodificado, por ejemplo, mostrarlo en la UI o realizar alguna acción.
  };

  const onScanFailure = (error) => {
    // console.warn(`Code scan error = ${error}`);
    // Puedes manejar los errores de escaneo aquí.
  };

  onMount(() => {
    scanner = new Html5QrcodeScanner(
      "reader",
      {
        fps: 10,
        qrbox: { width: 450, height: 450 },
        rememberLastUsedCamera: true,
        formatsToSupport: [
          0, // QR_CODE
          1, // AZTEC
          2, // CODABAR
          3, // CODE_39
          4, // CODE_93
          5, // CODE_128
          6, // DATA_MATRIX
          7, // MAXICODE
          8, // ITF
          9, // EAN_13
          10, // EAN_8
          11, // PDF_417
          12, // RSS_14
          13, // RSS_EXPANDED
          14, // UPC_A
          15, // UPC_E
          16, // UPC_EAN_EXTENSION
        ],
      },
      // verbose= false,
    );

    if (scannerValue) {
      scanner.pause();
      console.log(scannerValue);
    }

    scanner.render(onScanSuccess, onScanFailure);

    return () => {
      scanner.clear().catch((error) => {
        console.error("Error cleaning up scanner", error);
      });
    };
  });
</script>

<div id="reader"></div>

<style>
  #reader {
    width: 250px;
    height: 250px;
    margin: auto;
    border: 2px solid black;
    border-radius: 10px;
  }
</style>
