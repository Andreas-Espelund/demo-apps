{
  "aal"+: {
    "role"+: {
      ADMIN:"<ADMIN_USERS>",
      USER:"<USER_LIST>",
      MATRIKKELSOK:"<MATRIKKELSOK_USER>",
      INTEGRATOR:"<INTEGRATOR_USER>",
    },
    klient+: {
        url: "<AAL_KLIENT_URL>"
      }
  },
  "agresso"+: {
    "invoiceGenerationInterval": "0 0 4 ? * SUN",
    "type":"files4skip",
    "url":"<AGRESSO_URL>",
    "shareName":"aal",
  },
  "logging"+: {
    "level"+: {
      "root": "INFO",
      "no"+: {
        "kartverket"+: {
          "aal": "DEBUG"
        }
      }
    }
  },
  "spring"+: {
    "datasource"+: {
      "url": "<DATASOURCE_JDBC_URL>"
    }
  },
}
