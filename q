// Set up yargs to handle the new command-line argument
const argv = yargs(hideBin(process.argv))
  .option('buildNo', {
    alias: 'b',
    description: 'Build number to insert',
    type: 'string',
  })
  .option('env', {
    alias: 'e',
    description: 'Set the environment (lab or prod)',
    choices: ['lab', 'prod'],
    demandOption: true,  // Ensure this option is required
  })
  .argv;
