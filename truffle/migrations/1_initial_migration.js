const CollectionFactory = artifacts.require("./CollectionFactory.sol");
const Collection = artifacts.require("./Collection.sol");

module.exports = function (deployer) {
  deployer.deploy(Collection)
  deployer.deploy(CollectionFactory, Collection);
};
