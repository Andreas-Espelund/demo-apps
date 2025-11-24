{
  "aal"+: {
    "role"+: {
      "ADMIN": "<ADMIN_USERS>",
      "USER": "<USER_LIST>",
    },
    klient+: {
      url: "<AAL_KLIENT_URL>"
    }
  },
  "agresso"+: {
    "invoiceGenerationInterval": "0 */15 8-15 * * *",
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
