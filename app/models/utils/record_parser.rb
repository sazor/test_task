module Utils
  module Transform
    def self.name(str)
      str
    end
    def self.city(str)
      str
    end
    def self.country(str)
      str
    end
    def self.credential(str)
      str
    end
    def self.earned(str)
      Date.parse str
    end
    def self.status(str)
      str == "Active"
    end
  end

  class RecordParser
    include HTTParty
    base_uri "https://certification.pmi.org"

    # Strange var next line
    VIEWSTATE = { "__VIEWSTATE" => "/wEPDwUKMTM0NTk1MDU2Mw9kFgICAw9kFgICAw8UKwADDwWCAUM7QzpQTUkuV2ViLkZyYW1ld29yay5EeW5hbWljUGxhY2Vob2xkZXIsIFBNSS5XZWIsIFZlcnNpb249Mi4wLjU2NzguMzc2MzAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49bnVsbDtDb250ZW50UGxhY2Vob2xkZXIWAQ8FREM7VUM6QVNQLnJlZ2lzdHJ5X3JlZ2lzdHJ5Y29udGVudF9hc2N4Oi9SZWdpc3RyeTtkcGhfUmVnaXN0cnlDb250ZW50FgBkZBYCZg9kFgJmD2QWBAIHDxBkDxb5AWYCAQICAgMCBAIFAgYCBwIIAgkCCgILAgwCDQIOAg8CEAIRAhICEwIUAhUCFgIXAhgCGQIaAhsCHAIdAh4CHwIgAiECIgIjAiQCJQImAicCKAIpAioCKwIsAi0CLgIvAjACMQIyAjMCNAI1AjYCNwI4AjkCOgI7AjwCPQI+Aj8CQAJBAkICQwJEAkUCRgJHAkgCSQJKAksCTAJNAk4CTwJQAlECUgJTAlQCVQJWAlcCWAJZAloCWwJcAl0CXgJfAmACYQJiAmMCZAJlAmYCZwJoAmkCagJrAmwCbQJuAm8CcAJxAnICcwJ0AnUCdgJ3AngCeQJ6AnsCfAJ9An4CfwKAAQKBAQKCAQKDAQKEAQKFAQKGAQKHAQKIAQKJAQKKAQKLAQKMAQKNAQKOAQKPAQKQAQKRAQKSAQKTAQKUAQKVAQKWAQKXAQKYAQKZAQKaAQKbAQKcAQKdAQKeAQKfAQKgAQKhAQKiAQKjAQKkAQKlAQKmAQKnAQKoAQKpAQKqAQKrAQKsAQKtAQKuAQKvAQKwAQKxAQKyAQKzAQK0AQK1AQK2AQK3AQK4AQK5AQK6AQK7AQK8AQK9AQK+AQK/AQLAAQLBAQLCAQLDAQLEAQLFAQLGAQLHAQLIAQLJAQLKAQLLAQLMAQLNAQLOAQLPAQLQAQLRAQLSAQLTAQLUAQLVAQLWAQLXAQLYAQLZAQLaAQLbAQLcAQLdAQLeAQLfAQLgAQLhAQLiAQLjAQLkAQLlAQLmAQLnAQLoAQLpAQLqAQLrAQLsAQLtAQLuAQLvAQLwAQLxAQLyAQLzAQL0AQL1AQL2AQL3AQL4ARb5ARAFEFNlbGVjdCBhIENvdW50cnkFATBnEAULQWZnaGFuaXN0YW4FA0FGR2cQBQ7DhWxhbmQgSXNsYW5kcwUDQUxBZxAFB0FsYmFuaWEFA0FMQmcQBQdBbGdlcmlhBQNEWkFnEAUOQW1lcmljYW4gU2Ftb2EFA0FTTWcQBQdBbmRvcnJhBQNBTkRnEAUGQW5nb2xhBQNBR09nEAUIQW5ndWlsbGEFA0FJQWcQBQpBbnRhcmN0aWNhBQNBVEFnEAUTQW50aWd1YSBhbmQgQmFyYnVkYQUDQVRHZxAFCUFyZ2VudGluYQUDQVJHZxAFB0FybWVuaWEFA0FSTWcQBQVBcnViYQUDQUJXZxAFCUF1c3RyYWxpYQUDQVVTZxAFB0F1c3RyaWEFA0FVVGcQBQpBemVyYmFpamFuBQNBWkVnEAUHQmFoYW1hcwUDQkhTZxAFB0JhaHJhaW4FA0JIUmcQBQpCYW5nbGFkZXNoBQNCR0RnEAUIQmFyYmFkb3MFA0JSQmcQBQdCZWxhcnVzBQNCTFJnEAUHQmVsZ2l1bQUDQkVMZxAFBkJlbGl6ZQUDQkxaZxAFBUJlbmluBQNCRU5nEAUHQmVybXVkYQUDQk1VZxAFBkJodXRhbgUDQlROZxAFB0JvbGl2aWEFA0JPTGcQBSBCb25haXJlLCBTaW50IEV1c3RhdGl1cyBhbmQgU2FiYQUDQkVTZxAFFkJvc25pYSBhbmQgSGVyemVnb3ZpbmEFA0JJSGcQBQhCb3Rzd2FuYQUDQldBZxAFDUJvdXZldCBJc2xhbmQFA0JWVGcQBQZCcmF6aWwFA0JSQWcQBR5Ccml0aXNoIEluZGlhbiBPY2VhbiBUZXJyaXRvcnkFA0lPVGcQBRZCcml0aXNoIFZpcmdpbiBJc2xhbmRzBQNWR0JnEAURQnJ1bmVpIERhcnVzc2FsYW0FA0JSTmcQBQhCdWxnYXJpYQUDQkdSZxAFDEJ1cmtpbmEgRmFzbwUDQkZBZxAFB0J1cnVuZGkFA0JESWcQBQhDYW1ib2RpYQUDS0hNZxAFCENhbWVyb29uBQNDTVJnEAUGQ2FuYWRhBQNDQU5nEAUKQ2FwZSBWZXJkZQUDQ1BWZxAFDkNheW1hbiBJc2xhbmRzBQNDWU1nEAUYQ2VudHJhbCBBZnJpY2FuIFJlcHVibGljBQNDQUZnEAUEQ2hhZAUDVENEZxAFBUNoaWxlBQNDSExnEAUPQ2hpbmEsIG1haW5sYW5kBQNDSE5nEAUQQ2hyaXN0bWFzIElzbGFuZAUDQ1hSZxAFF0NvY29zIChLZWVsaW5nKSBJc2xhbmRzBQNDQ0tnEAUIQ29sb21iaWEFA0NPTGcQBQdDb21vcm9zBQNDT01nEAUQQ29uZ28sIERlbS4gUmVwLgUDQ09EZxAFC0NvbmdvLCBSZXAuBQNDT0dnEAUMQ29vayBJc2xhbmRzBQNDT0tnEAUKQ29zdGEgUmljYQUDQ1JJZxAFDkPDtHRlIGQnSXZvaXJlBQNDSVZnEAUHQ3JvYXRpYQUDSFJWZxAFBEN1YmEFA0NVQmcQBQhDdXJhw6dhbwUDQ1VXZxAFBkN5cHJ1cwUDQ1lQZxAFDkN6ZWNoIFJlcHVibGljBQNDWkVnEAUHRGVubWFyawUDRE5LZxAFCERqaWJvdXRpBQNESklnEAUIRG9taW5pY2EFA0RNQWcQBRJEb21pbmljYW4gUmVwdWJsaWMFA0RPTWcQBQdFY3VhZG9yBQNFQ1VnEAUFRWd5cHQFA0VHWWcQBQtFbCBTYWx2YWRvcgUDU0xWZxAFEUVxdWF0b3JpYWwgR3VpbmVhBQNHTlFnEAUHRXJpdHJlYQUDRVJJZxAFB0VzdG9uaWEFA0VTVGcQBQhFdGhpb3BpYQUDRVRIZxAFIUZhbGtsYW5kIElzbGFuZHMgKElzbGFzIE1hbHZpbmFzKQUDRkxLZxAFDUZhcm9lIElzbGFuZHMFA0ZST2cQBR5GZWRlcmF0ZWQgU3RhdGVzIG9mIE1pY3JvbmVzaWEFA0ZTTWcQBQRGaWppBQNGSklnEAUHRmlubGFuZAUDRklOZxAFBkZyYW5jZQUDRlJBZxAFDUZyZW5jaCBHdWlhbmEFA0dVRmcQBRBGcmVuY2ggUG9seW5lc2lhBQNQWUZnEAUbRnJlbmNoIFNvdXRoZXJuIFRlcnJpdG9yaWVzBQNBVEZnEAUFR2Fib24FA0dBQmcQBQZHYW1iaWEFA0dNQmcQBQdHZW9yZ2lhBQNHRU9nEAUHR2VybWFueQUDREVVZxAFBUdoYW5hBQNHSEFnEAUJR2licmFsdGFyBQNHSUJnEAUGR3JlZWNlBQNHUkNnEAUJR3JlZW5sYW5kBQNHUkxnEAUHR3JlbmFkYQUDR1JEZxAFCkd1YWRlbG91cGUFA0dMUGcQBQRHdWFtBQNHVU1nEAUJR3VhdGVtYWxhBQNHVE1nEAUGR3VpbmVhBQNHSU5nEAUNR3VpbmVhLUJpc3NhdQUDR05CZxAFBkd1eWFuYQUDR1VZZxAFBUhhaXRpBQNIVElnEAUhSGVhcmQgSXNsYW5kIGFuZCBNY0RvbmFsZCBJc2xhbmRzBQNITURnEAUISG9uZHVyYXMFA0hORGcQBQlIb25nIEtvbmcFA0hLR2cQBQdIdW5nYXJ5BQNIVU5nEAUHSWNlbGFuZAUDSVNMZxAFBUluZGlhBQNJTkRnEAUJSW5kb25lc2lhBQNJRE5nEAUZSXJhbiwgSXNsYW1pYyBSZXB1YmxpYyBvZgUDSVJOZxAFBElyYXEFA0lSUWcQBQdJcmVsYW5kBQNJUkxnEAUGSXNyYWVsBQNJU1JnEAUFSXRhbHkFA0lUQWcQBQdKYW1haWNhBQNKQU1nEAUFSmFwYW4FA0pQTmcQBQZKb3JkYW4FA0pPUmcQBQpLYXpha2hzdGFuBQNLQVpnEAUFS2VueWEFA0tFTmcQBQhLaXJpYmF0aQUDS0lSZxAFBkt1d2FpdAUDS1dUZxAFCkt5cmd5enN0YW4FA0tHWmcQBQRMYW9zBQNMQU9nEAUGTGF0dmlhBQNMVkFnEAUHTGViYW5vbgUDTEJOZxAFB0xlc290aG8FA0xTT2cQBQdMaWJlcmlhBQNMQlJnEAUWTGlieWFuIEFyYWIgSmFtYWhpcml5YQUDTEJZZxAFDUxpZWNodGVuc3RlaW4FA0xJRWcQBQlMaXRodWFuaWEFA0xUVWcQBQpMdXhlbWJvdXJnBQNMVVhnEAUFTWFjYW8FA01BQ2cQBSpNYWNlZG9uaWEsIFRoZSBGb3JtZXIgWXVnb3NsYXYgUmVwdWJsaWMgb2YFA01LRGcQBQpNYWRhZ2FzY2FyBQNNREdnEAUGTWFsYXdpBQNNV0lnEAUITWFsYXlzaWEFA01ZU2cQBQhNYWxkaXZlcwUDTURWZxAFBE1hbGkFA01MSWcQBQVNYWx0YQUDTUxUZxAFEE1hcnNoYWxsIElzbGFuZHMFA01ITGcQBQpNYXJ0aW5pcXVlBQNNVFFnEAUKTWF1cml0YW5pYQUDTVJUZxAFCU1hdXJpdGl1cwUDTVVTZxAFB01heW90dGUFA01ZVGcQBQZNZXhpY28FA01FWGcQBRRNb2xkb3ZhLCBSZXB1YmxpYyBvZgUDTURBZxAFBk1vbmFjbwUDTUNPZxAFCE1vbmdvbGlhBQNNTkdnEAUKTW9udGVuZWdybwUDTU5FZxAFCk1vbnRzZXJyYXQFA01TUmcQBQdNb3JvY2NvBQNNQVJnEAUKTW96YW1iaXF1ZQUDTU9aZxAFB015YW5tYXIFA01NUmcQBQdOYW1pYmlhBQNOQU1nEAUFTmF1cnUFA05SVWcQBQVOZXBhbAUDTlBMZxAFC05ldGhlcmxhbmRzBQNOTERnEAUUTmV0aGVybGFuZHMgQW50aWxsZXMFA0FOVGcQBQ1OZXcgQ2FsZWRvbmlhBQNOQ0xnEAULTmV3IFplYWxhbmQFA05aTGcQBQlOaWNhcmFndWEFA05JQ2cQBQVOaWdlcgUDTkVSZxAFB05pZ2VyaWEFA05HQWcQBQROaXVlBQNOSVVnEAUOTm9yZm9sayBJc2xhbmQFA05GS2cQBQtOb3J0aCBLb3JlYQUDUFJLZxAFGE5vcnRoZXJuIE1hcmlhbmEgSXNsYW5kcwUDTU5QZxAFBk5vcndheQUDTk9SZxAFBE9tYW4FA09NTmcQBQhQYWtpc3RhbgUDUEFLZxAFBVBhbGF1BQNQTFdnEAUTUGFsZXN0aW5lLCBTdGF0ZSBvZgUDUFNFZxAFBlBhbmFtYQUDUEFOZxAFEFBhcHVhIE5ldyBHdWluZWEFA1BOR2cQBQhQYXJhZ3VheQUDUFJZZxAFBFBlcnUFA1BFUmcQBQtQaGlsaXBwaW5lcwUDUEhMZxAFCFBpdGNhaXJuBQNQQ05nEAUGUG9sYW5kBQNQT0xnEAUIUG9ydHVnYWwFA1BSVGcQBQtQdWVydG8gUmljbwUDUFJJZxAFBVFhdGFyBQNRQVRnEAUIUsOpdW5pb24FA1JFVWcQBQdSb21hbmlhBQNST1VnEAUSUnVzc2lhbiBGZWRlcmF0aW9uBQNSVVNnEAUGUndhbmRhBQNSV0FnEAURU2FpbnQgQmFydGjDqWxlbXkFA0JMTWcQBQxTYWludCBIZWxlbmEFA1NITmcQBRVTYWludCBLaXR0cyBhbmQgTmV2aXMFA0tOQWcQBQtTYWludCBMdWNpYQUDTENBZxAFGlNhaW50IE1hcnRpbiAoRnJlbmNoIHBhcnQpBQNNQUZnEAUgU2FpbnQgVmluY2VudCBhbmQgdGhlIEdyZW5hZGluZXMFA1ZDVGcQBRlTYWludC1QaWVycmUgYW5kIE1pcXVlbG9uBQNTUE1nEAUFU2Ftb2EFA1dTTWcQBQpTYW4gTWFyaW5vBQNTTVJnEAUYU8OjbyBUb23DqSBhbmQgUHLDrW5jaXBlBQNTVFBnEAUMU2F1ZGkgQXJhYmlhBQNTQVVnEAUHU2VuZWdhbAUDU0VOZxAFBlNlcmJpYQUDU1JCZxAFFVNlcmJpYSBhbmQgTW9udGVuZWdybwUDU0NHZxAFClNleWNoZWxsZXMFA1NZQ2cQBQxTaWVycmEgTGVvbmUFA1NMRWcQBQlTaW5nYXBvcmUFA1NHUGcQBRlTaW50IE1hYXJ0ZW4gKER1dGNoIHBhcnQpBQNTWE1nEAUIU2xvdmFraWEFA1NWS2cQBQhTbG92ZW5pYQUDU1ZOZxAFD1NvbG9tb24gSXNsYW5kcwUDU0xCZxAFB1NvbWFsaWEFA1NPTWcQBQxTb3V0aCBBZnJpY2EFA1pBRmcQBSxTb3V0aCBHZW9yZ2lhIGFuZCB0aGUgU291dGggU2FuZHdpY2ggSXNsYW5kcwUDU0dTZxAFC1NvdXRoIEtvcmVhBQNLT1JnEAULU291dGggU3VkYW4FA1NTRGcQBQVTcGFpbgUDRVNQZxAFCVNyaSBMYW5rYQUDTEtBZxAFBVN1ZGFuBQNTRE5nEAUIU3VyaW5hbWUFA1NVUmcQBRZTdmFsYmFyZCBhbmQgSmFuIE1heWVuBQNTSk1nEAUJU3dhemlsYW5kBQNTV1pnEAUGU3dlZGVuBQNTV0VnEAULU3dpdHplcmxhbmQFA0NIRWcQBRRTeXJpYW4gQXJhYiBSZXB1YmxpYwUDU1lSZxAFGlRhaXdhbiAoUmVwdWJsaWMgb2YgQ2hpbmEpBQNUV05nEAUKVGFqaWtpc3RhbgUDVEpLZxAFHFRhbnphbmlhLCBVbml0ZWQgUmVwdWJsaWMgT2YFA1RaQWcQBQhUaGFpbGFuZAUDVEhBZxAFC1RpbW9yLUxlc3RlBQNUTFNnEAUEVG9nbwUDVEdPZxAFB1Rva2VsYXUFA1RLTGcQBQVUb25nYQUDVE9OZxAFE1RyaW5pZGFkIGFuZCBUb2JhZ28FA1RUT2cQBQdUdW5pc2lhBQNUVU5nEAUGVHVya2V5BQNUVVJnEAUMVHVya21lbmlzdGFuBQNUS01nEAUYVHVya3MgYW5kIENhaWNvcyBJc2xhbmRzBQNUQ0FnEAUGVHV2YWx1BQNUVVZnEAUTVS5TLiBWaXJnaW4gSXNsYW5kcwUDVklSZxAFBlVnYW5kYQUDVUdBZxAFB1VrcmFpbmUFA1VLUmcQBRRVbml0ZWQgQXJhYiBFbWlyYXRlcwUDQVJFZxAFDlVuaXRlZCBLaW5nZG9tBQNHQlJnEAUNVW5pdGVkIFN0YXRlcwUDVVNBZxAFJFVuaXRlZCBTdGF0ZXMgTWlub3IgT3V0bHlpbmcgSXNsYW5kcwUDVU1JZxAFB1VydWd1YXkFA1VSWWcQBQpVemJla2lzdGFuBQNVWkJnEAUHVmFudWF0dQUDVlVUZxAFB1ZhdGljYW4FA1ZBVGcQBQlWZW5lenVlbGEFA1ZFTmcQBQhWaWV0IE5hbQUDVk5NZxAFEVdhbGxpcyBhbmQgRnV0dW5hBQNXTEZnEAUOV2VzdGVybiBTYWhhcmEFA0VTSGcQBQVZZW1lbgUDWUVNZxAFBlphbWJpYQUDWk1CZxAFCFppbWJhYndlBQNaV0VnFgFmZAIJDxBkDxYJZgIBAgICAwIEAgUCBgIHAggWCRAFA0FsbAUBMGcQBQNQTVAFATFnEAUEQ0FQTQUBMmcQBQRQZ01QBQEzZxAFB1BNSS1STVAFATRnEAUGUE1JLVNQBQE1ZxAFB1BNSS1BQ1AFATZnEAUEUGZNUAUBN2cQBQdQTUktUEJBBQE4ZxYBZmQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja0tleV9fFgIFHEhlYWRlcjEkUE1JTG9naW5TdGF0dXMkY3RsMDEFHEhlYWRlcjEkUE1JTG9naW5TdGF0dXMkY3RsMDNJLTCURxwKrgNrBvRh4P3S/YOnMw==" }
    COUNTRY = { "dph_RegistryContent$wcountry" => "RUS" }
    LETTERS = ("A".."Z")
    LETTERS_PARAM = "dph_RegistryContent$tbSearch"
    ATTRIBUTES = [:name, :city, :country, :credential, :earned, :status]

    def run
      LETTERS.each do |letter|
        parse get_page(letter)
      end
    end

    private
    def parse(raw_page)
      attributes = {}
      page = Nokogiri::HTML(raw_page)
      page.css("tr").drop(1).each do |record|
        attributes = parse_record(record, attributes) # we need previous attrs because of empty fields
        create_record(attributes)
      end
    end

    def create_record(attributes)
      attributes[:uid] = get_uid(attributes) # uniq field to distinguish identical records
      Record.create(attributes) unless Record.where(uid: attributes[:uid]).exists?
    end

    def parse_record(record, prev_attrs)
      attrs = {}
      6.times do |i|
        td = record.css("td")[i]
        if column = td.css("span")[0] # if field isn't empty
          attrs[ATTRIBUTES[i]] = Transform.send(ATTRIBUTES[i], column.text) # parse string into proper format
        else
          attrs[ATTRIBUTES[i]] = prev_attrs[ATTRIBUTES[i]] # get data from previous record
        end
      end
      attrs
    end

    def get_page(letter)
      options = {
        body: { LETTERS_PARAM => letter }.merge(VIEWSTATE).merge(COUNTRY)
      }
      self.class.post('/registry.aspx', options)
    end

    def get_uid(attrs)
      Digest::MD5.hexdigest(attrs.values.join)
    end
  end
end