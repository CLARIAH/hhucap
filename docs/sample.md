# Sampling selection

Please see Schulz (2013) for details (pp.165-167) [link](https://dspace.library.uu.nl/bitstream/handle/1874/279589/schulz.pdf?sequence=2)


## Chosen newspapers
- Het Nieuws van den Dag: de kleine Courant
- Rotterdamsch Nieuwsblad
- Nieuwe Rotterdamsche Courant
- Nieuwe Tilburgsche Courant
- Leeuwarder Courant

This set reflects General, Liberal, Catholic and Lower, Middle and Higher social
classes as well national and regional newspapers from different parts of the
country.


## Sample
- goal: every 10th year since 1870 (a newspaper tax was abolished in 1869)


### Sampling issues:
- not everything was digitized yet)
- not always daily newspapers
- amount of ads per paper differs
- amount of ads within newspaper differs over time


### Actual sample:
- stratified
- produce a week for a newspaper, whereby days are from different months
- if more than 60 advertisements from a single newspaper issue: draw 60 randomly

Total Number of observations is 2194 ads.

### Sampling instructions

Use the harvest_metadata_public.py script that was sent to you, selecting [newspapers through their PPN](https://www.kb.nl/sites/default/files/docs/Beschikbare_kranten_alfabetisch.pdf). Usage:
```
python3 harvest_metadata_public.py 'ppns' start_year end_year
```

For example the ads from ppn 401028941 from 1901-01-01 to 1902-31-12:

```
python3 harvest_metadata_public.py "401028941" 1901 1902
```
