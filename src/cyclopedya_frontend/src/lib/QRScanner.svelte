<script>
  import { onMount } from 'svelte';
  import Quagga from 'quagga';

  onMount(() => {
    const initQuagga = () => {
      Quagga.init({
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: document.querySelector('#reader'),
          constraints: {
            width: { min: 640 },
            height: { min: 480 },
            facingMode: "environment", // Trata de usar la cámara trasera en dispositivos móviles
          },
        },
        decoder: {
          readers: ["ean_reader", "ean_8_reader", "ean_13_reader"], // Puedes agregar más lectores si es necesario
        },
        locate: true,
      }, (err) => {
        if (err) {
          console.error("Error al inicializar Quagga:", err);
          return;
        }
        console.log("Initialization finished. Ready to start");
        Quagga.start();
      });

      Quagga.onProcessed((result) => {
        const drawingCtx = Quagga.canvas.ctx.overlay;
        const drawingCanvas = Quagga.canvas.dom.overlay;

        // Configuración del contexto del canvas para mejorar el rendimiento
        drawingCanvas.getContext('2d', { willReadFrequently: true });

        if (result) {
          drawingCtx.clearRect(0, 0, drawingCanvas.width, drawingCanvas.height);

          if (result.boxes) {
            result.boxes.filter(box => box !== result.box).forEach(box => {
              Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, drawingCtx, { color: "green", lineWidth: 2 });
            });
          }

          if (result.box) {
            Quagga.ImageDebug.drawPath(result.box, { x: 0, y: 1 }, drawingCtx, { color: "#00F", lineWidth: 2 });
          }

          if (result.codeResult && result.codeResult.code) {
            Quagga.ImageDebug.drawPath(result.line, { x: 'x', y: 'y' }, drawingCtx, { color: 'red', lineWidth: 3 });
          }
        }
      });

      Quagga.onDetected((result) => {
        const code = result.codeResult.code;
        console.log("Barcode detected and processed: [" + code + "]", result);
        // Aquí puedes manejar el código decodificado
      });
    };

    navigator.mediaDevices.getUserMedia({ video: true })
      .then((stream) => {
        // Permisos de cámara concedidos
        initQuagga();
      })
      .catch((err) => {
        console.error("No se pudo acceder a la cámara: ", err);
      });

    return () => {
      Quagga.stop();
    };
  });
</script>

<style>
  #reader {
    width: 100%;
    max-width: 640px;
    height: 480px;
    margin: auto;
    border: 2px solid black;
    border-radius: 10px;
    position: relative;
    z-index: 10;
    margin-bottom: 50px;
  }
</style>

<div id="reader"></div>
