import 'models.dart';

const List<EthioRegion> _regions = <EthioRegion>[
  EthioRegion(
    id: 'addis_ababa',
    name: 'Addis Ababa',
    nameAmharic: 'አዲስ አበባ',
  ),
  EthioRegion(
    id: 'afar',
    name: 'Afar',
    nameAmharic: 'አፋር',
  ),
  EthioRegion(
    id: 'amhara',
    name: 'Amhara',
    nameAmharic: 'አማራ',
  ),
  EthioRegion(
    id: 'benishangul_gumuz',
    name: 'Benishangul-Gumuz',
    nameAmharic: 'ቤንሻንጉል-ጉሙዝ',
  ),
  EthioRegion(
    id: 'central_ethiopia',
    name: 'Central Ethiopia',
    nameAmharic: 'ማዕከላዊ ኢትዮጵያ',
  ),
  EthioRegion(
    id: 'dire_dawa',
    name: 'Dire Dawa',
    nameAmharic: 'ድሬ ዳዋ',
  ),
  EthioRegion(
    id: 'gambela',
    name: 'Gambela',
    nameAmharic: 'ጋምቤላ',
  ),
  EthioRegion(
    id: 'harari',
    name: 'Harari',
    nameAmharic: 'ሀረሪ',
  ),
  EthioRegion(
    id: 'oromia',
    name: 'Oromia',
    nameAmharic: 'ኦሮሚያ',
  ),
  EthioRegion(
    id: 'sidama',
    name: 'Sidama',
    nameAmharic: 'ሲዳማ',
  ),
  EthioRegion(
    id: 'somali',
    name: 'Somali',
    nameAmharic: 'ሶማሌ',
  ),
  EthioRegion(
    id: 'south_ethiopia',
    name: 'South Ethiopia',
    nameAmharic: 'ደቡብ ኢትዮጵያ',
  ),
  EthioRegion(
    id: 'south_west_ethiopia_peoples_region',
    name: "South West Ethiopia Peoples' Region",
    nameAmharic: 'ደቡብ ምዕራብ ኢትዮጵያ ሕዝቦች ክልል',
  ),
  EthioRegion(
    id: 'tigray',
    name: 'Tigray',
    nameAmharic: 'ትግራይ',
  ),
];

const List<EthioZone> _zones = <EthioZone>[
  EthioZone(
    id: 'afar_awsi',
    name: 'Awsi',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_kilbet_rasu',
    name: 'Kilbet Rasu',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_gabi_rasu',
    name: 'Gabi Rasu',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_fanti_rasu',
    name: 'Fanti Rasu',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_hari_rasu',
    name: 'Hari Rasu',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_mahi_rasu',
    name: 'Mahi Rasu',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'afar_argobba_special_woreda',
    name: 'Argobba Special Woreda',
    nameAmharic: '',
    regionId: 'afar',
  ),
  EthioZone(
    id: 'amhara_agew_awi',
    name: 'Agew Awi',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_east_gojjam',
    name: 'East Gojjam',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_north_gondar',
    name: 'North Gondar',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_central_gondar',
    name: 'Central Gondar',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_west_gondar',
    name: 'West Gondar',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_wag_hemra',
    name: 'Wag Hemra',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_west_gojjam',
    name: 'West Gojjam',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_bahir_dar_special_zone',
    name: 'Bahir Dar Special Zone',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_south_gondar',
    name: 'South Gondar',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_north_wollo',
    name: 'North Wollo',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_south_wollo',
    name: 'South Wollo',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_oromia_zone',
    name: 'Oromia Zone',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'amhara_north_shewa',
    name: 'North Shewa',
    nameAmharic: '',
    regionId: 'amhara',
  ),
  EthioZone(
    id: 'benishangul_asosa',
    name: 'Asosa',
    nameAmharic: '',
    regionId: 'benishangul_gumuz',
  ),
  EthioZone(
    id: 'benishangul_kamashi',
    name: 'Kamashi',
    nameAmharic: '',
    regionId: 'benishangul_gumuz',
  ),
  EthioZone(
    id: 'benishangul_metekel',
    name: 'Metekel',
    nameAmharic: '',
    regionId: 'benishangul_gumuz',
  ),
  EthioZone(
    id: 'central_east_gurage',
    name: 'East Gurage',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_gurage',
    name: 'Gurage',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_halaba',
    name: 'Halaba',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_hadiya',
    name: 'Hadiya',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_kebena_special_woreda',
    name: 'Kebena Special Woreda',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_kembata',
    name: 'Kembata',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_mareko_special_woreda',
    name: 'Mareko Special Woreda',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_silt_e',
    name: "Silt'e",
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_tembaro_special_woreda',
    name: 'Tembaro Special Woreda',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'central_yem',
    name: 'Yem',
    nameAmharic: '',
    regionId: 'central_ethiopia',
  ),
  EthioZone(
    id: 'gambela_anywaa',
    name: 'Anywaa',
    nameAmharic: '',
    regionId: 'gambela',
  ),
  EthioZone(
    id: 'gambela_majang',
    name: 'Majang',
    nameAmharic: '',
    regionId: 'gambela',
  ),
  EthioZone(
    id: 'gambela_nuer',
    name: 'Nuer',
    nameAmharic: '',
    regionId: 'gambela',
  ),
  EthioZone(
    id: 'harari_abadir',
    name: 'Abadir',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_amir_nur',
    name: 'Amir-Nur',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_aboker',
    name: 'Aboker',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_hakim',
    name: 'Hakim',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_jin_eala',
    name: "Jin'Eala",
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_shenkor',
    name: 'Shenkor',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_sofi',
    name: 'Sofi',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_erer',
    name: 'Erer',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'harari_dire_teyara',
    name: 'Dire-Teyara',
    nameAmharic: '',
    regionId: 'harari',
  ),
  EthioZone(
    id: 'oromia_arsi',
    name: 'Arsi',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_west_arsi',
    name: 'West Arsi',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_bale',
    name: 'East Bale',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_bale',
    name: 'Bale',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_borana',
    name: 'East Borana',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_borana',
    name: 'Borana',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_hararghe',
    name: 'East Hararghe',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_shewa',
    name: 'East Shewa',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_welega',
    name: 'East Welega',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_east_guji',
    name: 'East Guji',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_west_guji',
    name: 'West Guji',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_horo_guduru_welega',
    name: 'Horo Guduru Welega',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_illubabor',
    name: 'Illubabor',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_buno_bedele',
    name: 'Buno Bedele',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_jimma',
    name: 'Jimma',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_kelam_welega',
    name: 'Kelam Welega',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_north_shewa',
    name: 'North Shewa',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_southwest_shewa',
    name: 'Southwest Shewa',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_west_hararghe',
    name: 'West Hararghe',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_west_shewa',
    name: 'West Shewa',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_west_welega',
    name: 'West Welega',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'oromia_sheger_city',
    name: 'Sheger City',
    nameAmharic: '',
    regionId: 'oromia',
  ),
  EthioZone(
    id: 'sidama_central_sidama',
    name: 'Central Sidama',
    nameAmharic: '',
    regionId: 'sidama',
  ),
  EthioZone(
    id: 'sidama_eastern_sidama',
    name: 'Eastern Sidama',
    nameAmharic: '',
    regionId: 'sidama',
  ),
  EthioZone(
    id: 'sidama_northern_sidama',
    name: 'Northern Sidama',
    nameAmharic: '',
    regionId: 'sidama',
  ),
  EthioZone(
    id: 'sidama_southern_sidama',
    name: 'Southern Sidama',
    nameAmharic: '',
    regionId: 'sidama',
  ),
  EthioZone(
    id: 'somali_sitti',
    name: 'Sitti',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_fafan',
    name: 'Fafan',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_jarar',
    name: 'Jarar',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_erer',
    name: 'Erer',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_nogob',
    name: 'Nogob',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_dollo',
    name: 'Dollo',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_korahe',
    name: 'Korahe',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_shabelle',
    name: 'Shabelle',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_afder',
    name: 'Afder',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_liben',
    name: 'Liben',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_dhawa',
    name: 'Dhawa',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_jigjiga_special_zone',
    name: 'Jigjiga Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_tog_wajaale_special_zone',
    name: 'Tog Wajaale Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_degehabur_special_zone',
    name: 'Degehabur Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_gode_special_zone',
    name: 'Gode Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_kebri_beyah_special_zone',
    name: 'Kebri Beyah Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'somali_kebri_dahar_special_zone',
    name: 'Kebri Dahar Special Zone',
    nameAmharic: '',
    regionId: 'somali',
  ),
  EthioZone(
    id: 'south_ethiopia_ale',
    name: 'Ale',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_ari',
    name: 'Ari',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_basketo',
    name: 'Basketo',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_burji',
    name: 'Burji',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_gamo',
    name: 'Gamo',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_gardula',
    name: 'Gardula',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_gedeo',
    name: 'Gedeo',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_gofa',
    name: 'Gofa',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_konso',
    name: 'Konso',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_koore',
    name: 'Koore',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_south_omo',
    name: 'South Omo',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_ethiopia_wolayita',
    name: 'Wolayita',
    nameAmharic: '',
    regionId: 'south_ethiopia',
  ),
  EthioZone(
    id: 'south_west_bench_sheko',
    name: 'Bench Sheko',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'south_west_dawro',
    name: 'Dawro',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'south_west_keffa',
    name: 'Keffa',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'south_west_sheka',
    name: 'Sheka',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'south_west_konta',
    name: 'Konta',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'south_west_west_omo',
    name: 'West Omo',
    nameAmharic: '',
    regionId: 'south_west_ethiopia_peoples_region',
  ),
  EthioZone(
    id: 'tigray_central_tigray',
    name: 'Central Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_east_tigray',
    name: 'East Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_north_west_tigray',
    name: 'North West Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_west_tigray',
    name: 'West Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_south_tigray',
    name: 'South Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_south_east_tigray',
    name: 'South East Tigray',
    nameAmharic: '',
    regionId: 'tigray',
  ),
  EthioZone(
    id: 'tigray_mekele_special_zone',
    name: 'Mekele Special Zone',
    nameAmharic: '',
    regionId: 'tigray',
  ),
];

const List<EthioWoreda> _woredas = <EthioWoreda>[];

/// Returns an unmodifiable list of bundled first-level divisions (regions
/// and chartered cities).
List<EthioRegion> allRegions() => List<EthioRegion>.unmodifiable(_regions);

/// Returns the zones bundled for [regionId].
///
/// If the package does not include zones for the requested region this will
/// return an empty list. The returned list is unmodifiable.
List<EthioZone> zonesForRegion(String regionId) {
  return List<EthioZone>.unmodifiable(
    _zones.where((EthioZone zone) => zone.regionId == regionId),
  );
}

/// Returns the woredas bundled for [zoneId].
///
/// Woreda-level data is not included in this release; this function currently
/// returns an empty list for all zones. The API exists to allow consumers to
/// swap in their own woreda dataset if available.
List<EthioWoreda> woredasForZone(String zoneId) {
  return List<EthioWoreda>.unmodifiable(
    _woredas.where((EthioWoreda woreda) => woreda.zoneId == zoneId),
  );
}

/// Returns the `EthioRegion` matching [regionId], or `null` if none exists in
/// the bundled dataset.
EthioRegion? regionById(String regionId) {
  for (final region in _regions) {
    if (region.id == regionId) {
      return region;
    }
  }
  return null;
}
