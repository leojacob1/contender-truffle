// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../CollectionFactory.sol";
import "../Collection.sol";

contract CollectionFactoryTest is DSTest {
    CollectionFactory collectionFactory;
    Collection collection;

    function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function setUp() public {
        collection = new Collection();
        collectionFactory = new CollectionFactory(collection);
    }

    function testExample() public {
        Collection clone = collectionFactory.createCollection(
            "Cl-FROSH-342",
            "Frosh SZN",
            "Mo hits tanks",
            0x9bEF1f52763852A339471f298c6780e158E43A68,
            50000000000000000,
            25,
            0x750EF1D7a0b4Ab1c97B7A623D7917CcEb5ea779C,
            "QmcTFvGz8MbtcWVY4gLRTA7HNNBf3jmZ8NcjpNdRYSAiRd",
            stringToBytes32("QmZT2s1bghncPAmfMjZ3j1LhtjMXSECrMSLRXit6swfYAV")
        );
        emit log_address(address(clone));
        assertEq(clone.getCurrentTokenId(), 0);
        assertEq(clone.mintNFT{value: 50000000000000000}(), 1);

        emit log_address(clone.getAthleteAddress());
        emit log_address(clone.getAddressToPay());
        emit log_uint(clone.getPrice());
        emit log_uint(clone.getMaxSize());
        emit log(clone.getMetadataIpfsHash());
    }
}
