CREATE TABLE kasir (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  no_hp VARCHAR(20)
);

-- One to One: 1 kasir punya 1 akun
CREATE TABLE akun_kasir (
  id SERIAL PRIMARY KEY,
  kasir_id INT UNIQUE NOT NULL REFERENCES kasir(id) ON DELETE CASCADE,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE kategori_menu (
  id SERIAL PRIMARY KEY,
  nama_kategori VARCHAR(50) NOT NULL
);

-- One to Many: 1 kategori punya banyak menu
CREATE TABLE menu (
  id SERIAL PRIMARY KEY,
  kategori_id INT NOT NULL REFERENCES kategori_menu(id),
  nama VARCHAR(100) NOT NULL,
  harga NUMERIC(10,2) NOT NULL,
  stok INT DEFAULT 0
);

CREATE TABLE meja (
  id SERIAL PRIMARY KEY,
  nomor_meja INT UNIQUE NOT NULL,
  kapasitas INT NOT NULL
);

CREATE TABLE pelanggan (
  id SERIAL PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  no_hp VARCHAR(20)
);

-- One to Many: kasir, meja, pelanggan masing-masing punya banyak order
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  kasir_id INT NOT NULL REFERENCES kasir(id),
  meja_id INT NOT NULL REFERENCES meja(id),
  pelanggan_id INT REFERENCES pelanggan(id),
  tanggal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total NUMERIC(12,2) DEFAULT 0,
  status VARCHAR(20) DEFAULT 'pending'
);

-- Many to Many: orders <-> menu
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_id INT NOT NULL REFERENCES menu(id),
  jumlah INT NOT NULL,
  harga_satuan NUMERIC(10,2) NOT NULL,
  subtotal NUMERIC(12,2) NOT NULL
);

CREATE TABLE pembayaran (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  metode VARCHAR(30) NOT NULL,
  jumlah_bayar NUMERIC(12,2) NOT NULL,
  tanggal_bayar TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);