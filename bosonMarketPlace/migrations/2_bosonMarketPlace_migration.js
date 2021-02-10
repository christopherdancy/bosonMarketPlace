const bosonMarketPlace = artifacts.require("bosonMarketPlace");

module.exports = function(deployer) {
  deployer.deploy(bosonMarketPlace);
};
