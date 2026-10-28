require("dotenv").config();
const express = require("express");
const pool = require("./db");

const app = express();
app.use(express.json());

// GET semua menu
app.get("/menu", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM menu ORDER BY id");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET menu berdasarkan ID
app.get("/menu/:id", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM menu WHERE id = $1", [
      req.params.id,
    ]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Menu tidak ditemukan" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST tambah menu
app.post("/menu", async (req, res) => {
  try {
    const { kategori_id, nama, harga, stok } = req.body;
    const result = await pool.query(
      "INSERT INTO menu (kategori_id, nama, harga, stok) VALUES ($1, $2, $3, $4) RETURNING *",
      [kategori_id, nama, harga, stok],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT update menu
app.put("/menu/:id", async (req, res) => {
  try {
    const { kategori_id, nama, harga, stok } = req.body;
    const result = await pool.query(
      "UPDATE menu SET kategori_id = $1, nama = $2, harga = $3, stok = $4 WHERE id = $5 RETURNING *",
      [kategori_id, nama, harga, stok, req.params.id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Menu tidak ditemukan" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE hapus menu
app.delete("/menu/:id", async (req, res) => {
  try {
    const result = await pool.query(
      "DELETE FROM menu WHERE id = $1 RETURNING *",
      [req.params.id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Menu tidak ditemukan" });
    }
    res.json({ message: "Menu berhasil dihapus", data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server jalan di http://localhost:${PORT}`));
