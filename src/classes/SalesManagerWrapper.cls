/**
 * Created by anast on 29.10.2022.
 */

public with sharing class SalesManagerWrapper {
    private String name;
    private String email;

    private Boolean isSynced;

    public SalesManagerWrapper(String name, String email) {
        this.name = name;
        this.email = email;
    }
    public SalesManagerWrapper(String name, String email, Boolean isSynced) {
        this.name = name;
        this.email = email;
        this.isSynced = isSynced;
    }
}