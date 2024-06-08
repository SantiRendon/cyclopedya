<script>
  import "../index.scss";
  import { backend } from "$lib/canisters";
  import Card from "$lib/Card.svelte";
  import QRScanner from "$lib/QRScanner.svelte";
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
      const data = await backend.get_book_info("9780552144292").then((response) => {
      console.log("response:" + response);
    });
      return data;
    } catch (error) {
      console.log(error);
    }
  }

  onMount(async () => {
    data = await fetchData();
    console.log("data:",data);
  });
</script>

<!--
  <main>
    <img src="/logo2.svg" alt="DFINITY logo" />
    <br />
    <br />
    <form action="#" on:submit|preventDefault={onSubmit}>
      <label for="name">Enter your name: &nbsp;</label>
      <input id="name" alt="Name" type="text" />
      <button type="submit">Click Me!</button>
    </form>
    <section id="greeting">{greeting}</section>

  </main>

-->  

<main>
  <div style="text-align: center;">
    <h3>Escanea el codigo de barras de tu libro</h3>
    <QRScanner />
  </div>
</main>

<main>
  <Card />
</main>
