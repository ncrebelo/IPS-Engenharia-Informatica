import datetime


class MyDateTime:
    @classmethod
    def getDate(cls):
        dt = cls.getDate_and_Time().now
        return dt.strftime('%d/%m/%Y')

    @classmethod
    def getTime(cls):
        dt = cls.getTime_and_Date().now
        return dt.strftime('%H:%M:%S')

    @classmethod
    def getTime_and_Date(cls):
        return cls.getTime() + " " + MyDateTime.getDate()

    @classmethod
    def getDate_and_Time(cls):
        return MyDateTime.getDate() + " " + MyDateTime.getTime()

    @classmethod
    def dateFormat(cls, timestamp):
        return timestamp.strftime('%d/%m/%Y')

    @classmethod
    def timeFormat(cls, timestamp):
        return timestamp.strftime('%H:%M:%S')

    @classmethod
    def time_and_DateFormat(cls, timestamp):
        return timestamp.strftime('%H:%M:%S') + " " + timestamp.strftime('%d/%m/%Y')

    @classmethod
    def date_and_TimeFormat(cls, timestamp):
        return timestamp.strftime('%d/%m/%Y') + ">" + " <" + timestamp.strftime('%H:%M:%S')

    @classmethod
    def httpDate_and_TimeFormat(cls, timestamp):
        return timestamp.strftime('%a, %d %b %Y %H:%M:%S GMT')

    @classmethod
    def getTimestamp(cls):
        return datetime.datetime.now()

    @classmethod
    def httpFormattedDate_and_Time(cls):
        return cls.httpDate_and_TimeFormat(datetime.datetime.now())
