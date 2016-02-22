DROP TABLE IF EXISTS `newsletter`;
CREATE TABLE `newsletter` (
  `nome` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `cognome` char(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` char(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
