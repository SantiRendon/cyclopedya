<script>
    import { onMount } from "svelte";
    import { backend } from "$lib/canisters";

    export let isbn;

    let isLoading = false;

    let book = {
        title: "",
        isbn: "",
        subjects: "",
        author: "",
        preview: "",
        info_url: "",
        cover: "",
    };

    function resizeImageUrl(url) {
        if (url.endsWith("-S.jpg")) {
            return url.replace("-S.jpg", "-L.jpg");
        } else {
            return url;
        }
    }

    async function fetchInfoBook(isbnValue) {
        try {
            isLoading = true;
            const data = await backend.get_book_info(isbnValue);
            return JSON.parse(data).docs[0];
        } catch (error) {
            console.log(error);
        }
    }

    async function fetchUrlBook(isbnValue) {
        try {
            isLoading = true;
            const data = await backend.get_book_urls(isbnValue);
            return JSON.parse(data)[`ISBN:${isbn}`];
        } catch (error) {
            console.log(error);
        }
    }

    onMount(async () => {
        try {
            // Obtener la información del libro y las URLs asociadas
            const info = await fetchInfoBook(isbn);
            const urls = await fetchUrlBook(isbn);

            // Mostrar la información del libro en la consola
            console.log(info);

            // Redimensionar la imagen de la portada
            const newCover = resizeImageUrl(urls.thumbnail_url);

            // Crear el objeto del libro con la información obtenida
            book = {
                title: info.title,
                isbn: isbn,
                subjects: info.subject,
                author: info.author_name,
                preview: urls.preview_url,
                info_url: urls.info_url,
                cover: newCover,
                ratings_average: info.ratings_average,
            };

            // Cambiar el estado de carga a falso
            isLoading = false;

            return book;
        } catch (error) {
            console.error("Error fetching book details:", error);
            isLoading = false;
        }
    });
</script>

{#if isLoading}
    <sl-spinner
        style="font-size: 100px; --track-width: 10px; margin-top: 2.5rem;"
    ></sl-spinner>
{:else}
    <sl-card class="card-overview">
        <img
            slot="image"
            src={book.cover}
            alt="A kitten sits patiently between a terracotta pot and decorative grasses."
        />

        <div style="text-align: center">
            <strong>{book?.title} - {book?.isbn}</strong><br />
            <!-- <p>{book?.preview}</p> -->
            <p>{book?.author}</p>
            <small>{book?.subjects[2]}</small>
        </div>

        <div slot="footer">
            <sl-button
                pill
                variant="primary"
                href={book.info_url}
                target="blank">More Info</sl-button
            >
            <sl-rating label="Rating" precision="0.5" readonly value={book.ratings_average}
            ></sl-rating>
        </div>
    </sl-card>
{/if}

<style>
    .card-overview {
        max-width: 350px;
    }

    .card-overview small {
        color: var(--sl-color-neutral-500);
    }

    .card-overview [slot="footer"] {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
</style>
