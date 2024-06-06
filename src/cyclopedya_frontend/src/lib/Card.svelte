<script>
    let book = {
    title : "Mort",
    isbn: "9780552144292",
    subjects: [ "Drama texts: from c 1900 -","General", "Fiction - Fantasy"],
    cover: "./cover.jpg",
    author: "Terry Pratchet",
    first_sentence: "his is the bright candlelit room where the life-timers are stored-shelf",
    info_url: "https://openlibrary.org/books/OL7815144M/Mort",
    save_button: "function()"
}



</script>

<sl-card class="card-overview">
    <img
        slot="image"
        src="https://images.unsplash.com/photo-1559209172-0ff8f6d49ff7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80"
        alt="A kitten sits patiently between a terracotta pot and decorative grasses."
    />

    <strong>{book.title} - {book.isbn}</strong><br />
    <p>{book.first_sentence}</p>
    <p>{book.subjects[2]}</p>
    <small>{book.author}</small>

    <div slot="footer">
        <sl-button pill variant="primary" href={book.info_url} target="blank">More Info</sl-button>
        <sl-button pill>Save Book</sl-button>
        
    </div>
</sl-card>

<style>
    .card-overview {
        max-width: 400px;
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
