<script>
  import "../index.scss";
  import { backend } from "$lib/canisters";
  import Card from "$lib/Card.svelte";
  import QRScanner from "$lib/QRScanner.svelte";
  import Carrusel from "$lib/Carrusel.svelte";
  import { onMount } from "svelte";

  let greeting = "";
  let data = [];

  function onSubmit(event) {
    const name = event.target.name.value;
    backend.greet(name).then((response) => {
      greeting = response;
    });
    return false;
  }

  async function fetchData() {
    try {
      const data = await backend.get_book_info("9780552144292");
      return JSON.parse(data);
    } catch (error) {
      console.log(error);
    }
  }

  onMount(async () => {
    data = await fetchData();
    console.log("data:", data);
  });
</script>

<main>
  <div class="container">
    <Carrusel />
    <h3>Escanea el codigo de barras de tu libro</h3>
    <QRScanner />

    <Card />
  </div>
</main>

<style>
  .container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    text-align: center;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
  }

  h3 {
    margin-top: 20px;
    font-size: 24px;
    color: #333;
  }
</style>
