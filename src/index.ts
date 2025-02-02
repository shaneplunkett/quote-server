import { PrismaClient } from '@prisma/client';
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

const prisma = new PrismaClient();

const typeDefs = `#graphql
type User {
    userid: String
    email: String
    name: String
    password: String
    token: String
    expiry: String
    revoked: Boolean
    }

type Query {
    getUser(email: String!): User
}
`;

const resolvers = {
  Query: {
    getUser: (_, { email }) => {
      return prisma.user.findUnique({
        where: {
          email: email,
        },
      });
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
