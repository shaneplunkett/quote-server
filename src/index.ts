import { PrismaClient } from '@prisma/client';
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

const prisma = new PrismaClient();

const typeDefs = `#graphql

    type MainSku {
        id: Int
        sku_id: String 
    }

    type Query {
        getMainSkus: [MainSku]
}
`;

const resolvers = {
  Query: {
    getMainSkus: async () => {
      return await prisma.mainSku.findMany();
    },
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

const { url } = await startStandaloneServer(server, {
  listen: { port: 4000 },
});

console.log(`🚀  Server ready at: ${url}`);
