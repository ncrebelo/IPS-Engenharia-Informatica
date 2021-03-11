package com.pa.proj2020.model;

import java.io.Serializable;

/**
 * Utilizador Adicionado, explicitamente adicionado através do identificador
 */
public class UserAdded implements UserStrategy, Serializable {

    @Override
    public String toString() {
        return "Utilizador Adicionado";
    }
}
