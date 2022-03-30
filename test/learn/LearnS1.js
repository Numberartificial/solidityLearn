// We import Chai to use its asserting functions here.
const { expect } = require("chai");

// `describe` is a Mocha function that allows you to organize your tests. It's
// not actually needed, but having your tests organized makes debugging them
// easier. All Mocha functions are available in the global scope.

// `describe` receives the name of a section of your test suite, and a callback.
// The callback must define the tests of that section. This callback can't be
// an async function.
describe("learn", function () {
  // Mocha has four functions that let you hook into the the test runner's
  // lifecyle. These are: `before`, `beforeEach`, `after`, `afterEach`.

  // They're very useful to setup the environment for tests, and to clean it
  // up after they run.

  // A common pattern is to declare some variables, and assign them in the
  // `before` and `beforeEach` callbacks.

  let lib;
  let hackMe;
  let attack;

  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    let d1 = await ethers.getContractFactory("HackedLib");
    let d2 = await ethers.getContractFactory("HackMe");
    let d3 = await ethers.getContractFactory("Attack");
    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    // hardhatToken = await Token.deploy(amount);
    lib = await d1.deploy(addr2.address);
    hackMe = await d2.deploy(addr1.address, lib.address);
    attack = await d3.deploy(hackMe.address);
  });

  // You can nest describe calls to create subsections.
  describe("Deployment", function () {
    // `it` is another Mocha function. This is the one you use to define your
    // tests. It receives the test name, and a callback function.

    // If the callback function is async, Mocha will `await` it.
    it("Should set the right owner", async function () {
      // Expect receives a value, and wraps it in an Assertion object. These
      // objects have a lot of utility methods to assert values.

      // This test expects the owner variable stored in the contract to be equal
      // to our Signer's owner.
      expect(await lib.owner()).to.equal(addr2.address);
      expect(await hackMe.owner()).to.equal(addr1.address);
    });

  });

  describe("Attack", function () {
    it("Should attack changing the lib owner", async function () {
      await attack.attack();
      const hackMeOwner = await hackMe.owner();
      expect(hackMeOwner).to.equal(await attack.attacker());

    });

  });

});