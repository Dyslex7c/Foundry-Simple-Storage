// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testStoreAndRetrieve() public {
        uint256 expectedFavoriteNumber = 7;
        simpleStorage.store(expectedFavoriteNumber);

        uint256 retrievedNumber = simpleStorage.retrieve();
        assertEq(retrievedNumber, expectedFavoriteNumber, "The retrieved number should match the stored number");
    }

    function testAddPerson() public {
        string memory name = "Alice";
        uint256 favoriteNumber = 7;

        simpleStorage.addPerson(name, favoriteNumber);

        (uint256 retrievedFavoriteNumber, string memory retrievedName) = simpleStorage.people(0);
        assertEq(retrievedFavoriteNumber, favoriteNumber, "Favorite number should match the one added");
        assertEq(keccak256(bytes(retrievedName)), keccak256(bytes(name)), "Name should match the one added");

        uint256 mappedFavoriteNumber = simpleStorage.nameToFavoriteNumber(name);
        assertEq(mappedFavoriteNumber, favoriteNumber, "Mapping should return the correct favorite number");
    }

    function testMultiplePeople() public {
        string memory name1 = "Alice";
        uint256 favoriteNumber1 = 7;
        string memory name2 = "Bob";
        uint256 favoriteNumber2 = 9;

        simpleStorage.addPerson(name1, favoriteNumber1);
        simpleStorage.addPerson(name2, favoriteNumber2);

        (uint256 retrievedFavoriteNumber1, string memory retrievedName1) = simpleStorage.people(0);
        assertEq(retrievedFavoriteNumber1, favoriteNumber1, "Favorite number 1 should match");
        assertEq(keccak256(bytes(retrievedName1)), keccak256(bytes(name1)), "Name 1 should match");

        (uint256 retrievedFavoriteNumber2, string memory retrievedName2) = simpleStorage.people(1);
        assertEq(retrievedFavoriteNumber2, favoriteNumber2, "Favorite number 2 should match");
        assertEq(keccak256(bytes(retrievedName2)), keccak256(bytes(name2)), "Name 2 should match");

        assertEq(simpleStorage.nameToFavoriteNumber(name1), favoriteNumber1, "Mapping for Alice should be correct");
        assertEq(simpleStorage.nameToFavoriteNumber(name2), favoriteNumber2, "Mapping for Bob should be correct");
    }
}
