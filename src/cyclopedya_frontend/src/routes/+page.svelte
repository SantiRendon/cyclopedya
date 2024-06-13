<script>
  import "../index.scss";
  import Card from "$lib/Card.svelte";
  import QRScanner from "$lib/QRScanner.svelte";
  import Carrusel from "$lib/Carrusel.svelte";
  import { scannerValue } from "$lib/stores";

  let isbn;

  scannerValue.subscribe((value) => {
    isbn = value;
  });

  function clearScan() {
    isbn = null;
    console.log("clear");
  }
</script>

<main>
  <div class="container">
    <Carrusel />
    <section class="title-section">
      <h3>Escanea el codigo de barras de tu libro</h3>
      <button on:click={clearScan} style="position: relative; left: 70px;">
        <sl-icon
          name="arrow-repeat"
          label="Edit"
          style="font-size: 1.5rem;"
        ></sl-icon>
      </button>
    </section>
    {#if isbn}
      <Card {isbn} />
    {:else}
      <QRScanner />
    {/if}
  </div>
</main>

<style>
  .container {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    max-width: 800px;
    margin: 0 auto;
    padding-bottom: 5rem;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
  }

  h3 {
    margin-top: 20px;
    font-size: 24px;
    color: #333;
  }

  .title-section {
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
