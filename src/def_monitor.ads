package def_monitor is

    protected type MaitreMonitor is
        entry maitreLock;
        procedure maitreLock;
        entry matriUnlock;
        procedure matriUnlock;

    private
        maxMesas   : Integer := 3;
        maxSalones : Integer := 3;

    end MaitreMonitor;

end def_monitor;
