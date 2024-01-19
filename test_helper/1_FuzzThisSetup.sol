// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { FuzzThis } from "../src/1_FuzzThis.sol";

contract FuzzThisHelper {

    FuzzThis public deployed;

    constructor() {
        deployed = new FuzzThis(2552);
    }

}