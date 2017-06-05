from gmsdk import md

ret = md.init("13601380996",
              "it@iZ23psatkqsZ",
              2,
              "SHFE.RU1709.bar.60")

ticks = md.get_ticks("SHSE.600000,SZSE.000001",
                     "2017-06-01 09:30:00",
                     "2017-06-01 09:31:00")

print(ticks)

ret = md.init("13601380996",
              "it@iZ23psatkqsZ",
              4,
              "SHFE.ru1709.tick")


ti = md.get_ticks("SHFE.ru1709.tick","2017-06-01 09:30:00","2017-06-01 09:31:00")

print("aaa!")
print(ti)