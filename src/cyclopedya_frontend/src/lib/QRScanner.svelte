<script>
    import { onMount } from 'svelte';
    import { Html5QrcodeScanner } from 'html5-qrcode';
  
    let scanner;
  
    const onScanSuccess = (decodedText, decodedResult) => {
      console.log(`Code matched = ${decodedText}`, decodedResult);
      // Aquí puedes manejar el texto decodificado, por ejemplo, mostrarlo en la UI o realizar alguna acción.
    };
  
    const onScanFailure = (error) => {
      console.warn(`Code scan error = ${error}`);
      // Puedes manejar los errores de escaneo aquí.
    };
  
    onMount(() => {
      scanner = new Html5QrcodeScanner(
        "reader", 
        { fps: 10, qrbox: { width: 250, height: 250 } },
        /* verbose= */ false
      );
  
      scanner.render(onScanSuccess, onScanFailure);
      
      return () => {
        scanner.clear().catch(error => {
          console.error('Error cleaning up scanner', error);
        });
      };
    });
  </script>
  
  <style>
    #reader {
      width: 300px;
      height: 300px;
      margin: auto;
    }
  </style>
  
  <div id="reader"></div>
  