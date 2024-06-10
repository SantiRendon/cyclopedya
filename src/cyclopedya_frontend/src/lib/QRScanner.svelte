<script>
  import { onMount } from "svelte";
  import { Html5QrcodeScanner } from "html5-qrcode";
  import { writable } from "svelte/store";

  let scannerValue = writable(null);
  let scanner;
  let isScanning;

  scannerValue.subscribe(async (value) => {
    if (value && isScanning) {
      await scanner.clear();
      isScanning = false;
      console.log(value);
    }
  });

  const onScanSuccess = (decodedText, decodedResult) => {
    scannerValue.set(decodedResult.result.text);
  };

  const onScanFailure = (error) => {
    // Manejar los errores de escaneo aquí.
    // console.warn(`Code scan error = ${error}`);
  };

  onMount(() => {
    scanner = new Html5QrcodeScanner("reader", {
      fps: 10,
      qrbox: { width: 450, height: 450 },
      rememberLastUsedCamera: true,
      formatsToSupport: [
        9, // EAN_13
      ],
    });

    scanner.render(onScanSuccess, onScanFailure);

    isScanning = true;
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
